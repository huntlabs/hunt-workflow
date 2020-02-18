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


import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import flow.common.interceptor.CommandContext;
import org.flowable.job.service.impl.history.async.transformer.HistoryJsonTransformer;
import org.flowable.job.service.impl.persistence.entity.HistoryJobEntity;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.node.ObjectNode;

class AsyncHistoryJobHandler extends AbstractAsyncHistoryJobHandler {

    protected Map<string, List<HistoryJsonTransformer>> historyJsonTransformers = new HashMap<>();
    protected HistoryJsonTransformer defaultHistoryJsonTransformer;
    
    public AsyncHistoryJobHandler(string jobType) {
        super(jobType);
    }

    public void addHistoryJsonTransformer(HistoryJsonTransformer historyJsonTransformer) {
        List<string> types = historyJsonTransformer.getTypes();

        for (string type : types) {
            if (!historyJsonTransformers.containsKey(type)) {
                historyJsonTransformers.put(type, new ArrayList<>());
            }
            historyJsonTransformers.get(type).add(historyJsonTransformer);
        }
    }

    @Override
    protected void processHistoryJson(CommandContext commandContext, HistoryJobEntity job, JsonNode historyNode) {
        
        string type = null;
        if (historyNode.has(HistoryJsonTransformer.FIELD_NAME_TYPE)) {
            type = historyNode.get(HistoryJsonTransformer.FIELD_NAME_TYPE).asText();
        }
        ObjectNode historicalJsonData = (ObjectNode) historyNode.get(HistoryJsonTransformer.FIELD_NAME_DATA);

        if (logger.isTraceEnabled()) {
            logger.trace("Handling async history job (id={}, type={})", job.getId(), type);
        }

        List<HistoryJsonTransformer> transformers = historyJsonTransformers.get(type);
        if (transformers !is null && !transformers.isEmpty()) {
            executeHistoryTransformers(commandContext, job, historicalJsonData, transformers);
        } else {
            handleNoMatchingHistoryTransformer(commandContext, job, historicalJsonData, type);
        }
    }

    protected void executeHistoryTransformers(CommandContext commandContext, HistoryJobEntity job,
            ObjectNode historicalJsonData, List<HistoryJsonTransformer> transformers) {
        for (HistoryJsonTransformer transformer : transformers) {
            if (transformer.isApplicable(historicalJsonData, commandContext)) {
                transformer.transformJson(job, historicalJsonData, commandContext);

            } else {
                if (logger.isDebugEnabled()) {
                    logger.debug("Could not handle history job (id={}) for transformer {}. as it is not applicable. Unacquiring. {}", job.getId(), transformer.getTypes(), historicalJsonData);
                }
                throw new AsyncHistoryJobNotApplicableException("Job is not applicable for transformer types: " + transformer.getTypes());

            }
        }
    }

    protected void handleNoMatchingHistoryTransformer(CommandContext commandContext, HistoryJobEntity job, ObjectNode historicalData, string type) {
        if (defaultHistoryJsonTransformer !is null) {
            if (defaultHistoryJsonTransformer.isApplicable(historicalData, commandContext)) {
                defaultHistoryJsonTransformer.transformJson(job, historicalData, commandContext);
            } else {
                throw new AsyncHistoryJobNotApplicableException("Job is not applicable for default history json transformer types: " + defaultHistoryJsonTransformer.getTypes());
            }
        } else {
            logger.warn("Cannot transform history json: no transformers found for type {}", type);
        }
    }

    public Map<string, List<HistoryJsonTransformer>> getHistoryJsonTransformers() {
        return historyJsonTransformers;
    }

    public void setHistoryJsonTransformers(Map<string, List<HistoryJsonTransformer>> historyJsonTransformers) {
        this.historyJsonTransformers = historyJsonTransformers;
    }

    public HistoryJsonTransformer getDefaultHistoryJsonTransformer() {
        return defaultHistoryJsonTransformer;
    }

    public void setDefaultHistoryJsonTransformer(HistoryJsonTransformer defaultHistoryJsonTransformer) {
        this.defaultHistoryJsonTransformer = defaultHistoryJsonTransformer;
    }
    
}
