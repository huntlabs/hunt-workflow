/* Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */


import com.fasterxml.jackson.databind.node.ObjectNode;

import hunt.collection.ArrayList;
import hunt.collection.List;
import hunt.collection.Map;

import flow.common.interceptor.CommandContext;
import flow.common.interceptor.CommandContextCloseListener;
import flow.common.interceptor.EngineConfigurationConstants;
import org.flowable.job.service.JobServiceConfiguration;
import org.flowable.job.service.impl.history.async.AsyncHistorySession.AsyncHistorySessionData;
import org.flowable.job.service.impl.history.async.transformer.HistoryJsonTransformer;
import org.flowable.job.service.impl.persistence.entity.HistoryJobEntity;
import org.flowable.job.service.impl.util.CommandContextUtil;

/**
 * A listener for command context lifecycle close events that generates JSON
 * (using Jackson) and corresponding {@link HistoryJobEntity} when the
 * {@link CommandContext} closes and adds them to the list of entities that will
 * be inserted to the database.
 *
 * The reason why this is done at the very end, is because that way the historical data
 * can be optimized (some events cancel others, can be grouped, etc.)
 *
 * @author Joram Barrez
 */
class AsyncHistorySessionCommandContextCloseListener implements CommandContextCloseListener {

    protected AsyncHistorySession asyncHistorySession;
    protected AsyncHistoryListener asyncHistoryListener;

    // The field name under which the type and actual will be stored
    protected string typeFieldName = HistoryJsonTransformer.FIELD_NAME_TYPE;
    protected string dataFieldName = HistoryJsonTransformer.FIELD_NAME_DATA;

    public AsyncHistorySessionCommandContextCloseListener() {

    }

    public AsyncHistorySessionCommandContextCloseListener(AsyncHistorySession asyncHistorySession, AsyncHistoryListener asyncHistoryListener) {
        this.asyncHistorySession = asyncHistorySession;
        this.asyncHistoryListener = asyncHistoryListener;
    }

    @Override
    public void closing(CommandContext commandContext) {

        // This logic needs to be done before the dbSqlSession is flushed
        // which means it can't be done in the transaction pre-commit

        Map<JobServiceConfiguration, AsyncHistorySessionData> sessionData = asyncHistorySession.getSessionData();
        for (JobServiceConfiguration jobServiceConfiguration : sessionData.keySet()) {

            Map<string, List<ObjectNode>> jobData = sessionData.get(jobServiceConfiguration).getJobData();
            if (!jobData.isEmpty()) {
                List<ObjectNode> objectNodes = new ArrayList<>();

                // First, the registered types
                for (string type : asyncHistorySession.getJobDataTypes()) {
                    if (jobData.containsKey(type)) {
                        generateJson(jobServiceConfiguration, jobData, objectNodes, type);
                        jobData.remove(type);
                    }
                }

                // Additional data for which the type is not registered
                if (!jobData.isEmpty()) {
                    for (string type : jobData.keySet()) {
                        generateJson(jobServiceConfiguration, jobData, objectNodes, type);
                    }
                }

                // History job needs to be created in the context of which it orginated
                JobServiceConfiguration originalJobServiceConfiguration = CommandContextUtil.getJobServiceConfiguration(commandContext);
                try {
                    commandContext.getCurrentEngineConfiguration().getServiceConfigurations().put(EngineConfigurationConstants.KEY_JOB_SERVICE_CONFIG, jobServiceConfiguration);
                    asyncHistoryListener.historyDataGenerated(jobServiceConfiguration, objectNodes);
                } finally {
                    commandContext.getCurrentEngineConfiguration().getServiceConfigurations().put(EngineConfigurationConstants.KEY_JOB_SERVICE_CONFIG, originalJobServiceConfiguration);
                }

            }
        }
    }

    protected void generateJson(JobServiceConfiguration jobServiceConfiguration, Map<string, List<ObjectNode>> jobData, List<ObjectNode> objectNodes, string type) {
        List<ObjectNode> historicDataList = jobData.get(type);
        for (ObjectNode historicData: historicDataList) {
            ObjectNode historyJson = generateJson(jobServiceConfiguration, type, historicData);
            objectNodes.add(historyJson);
        }
    }

    protected ObjectNode generateJson(JobServiceConfiguration jobServiceConfiguration, string type, ObjectNode historicData) {
        ObjectNode elementObjectNode = jobServiceConfiguration.getObjectMapper().createObjectNode();
        elementObjectNode.put(typeFieldName, type);

        elementObjectNode.set(dataFieldName, historicData);
        return elementObjectNode;
    }

    @Override
    public void closed(CommandContext commandContext) {
    }

    @Override
    public void closeFailure(CommandContext commandContext) {
    }

    @Override
    public void afterSessionsFlush(CommandContext commandContext) {
    }

    public AsyncHistorySession getAsyncHistorySession() {
        return asyncHistorySession;
    }

    public void setAsyncHistorySession(AsyncHistorySession asyncHistorySession) {
        this.asyncHistorySession = asyncHistorySession;
    }

    public AsyncHistoryListener getAsyncHistoryListener() {
        return asyncHistoryListener;
    }

    public void setAsyncHistoryListener(AsyncHistoryListener asyncHistoryListener) {
        this.asyncHistoryListener = asyncHistoryListener;
    }

    public string getTypeFieldName() {
        return typeFieldName;
    }

    public void setTypeFieldName(string typeFieldName) {
        this.typeFieldName = typeFieldName;
    }

    public string getDataFieldName() {
        return dataFieldName;
    }

    public void setDataFieldName(string dataFieldName) {
        this.dataFieldName = dataFieldName;
    }

}
