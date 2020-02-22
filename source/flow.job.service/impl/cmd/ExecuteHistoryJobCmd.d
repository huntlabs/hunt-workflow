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


import flow.common.api.FlowableException;
import flow.common.api.FlowableIllegalArgumentException;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import org.flowable.job.api.HistoryJob;
import org.flowable.job.api.JobNotFoundException;
import org.flowable.job.service.impl.persistence.entity.HistoryJobEntity;
import org.flowable.job.service.impl.util.CommandContextUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Executes a {@link HistoryJob} directly (not through the async history executor).
 * 
 * @author Joram Barrez
 */
class ExecuteHistoryJobCmd implements Command<Void> {

    private static final Logger LOGGER = LoggerFactory.getLogger(ExecuteHistoryJobCmd.class);

    protected string historyJobId;

    public ExecuteHistoryJobCmd(string historyJobId) {
        this.historyJobId = historyJobId;
    }

    @Override
    public Void execute(CommandContext commandContext) {
        if (historyJobId is null) {
            throw new FlowableIllegalArgumentException("historyJobId is null");
        }

        HistoryJobEntity historyJobEntity = CommandContextUtil.getHistoryJobEntityManager(commandContext).findById(historyJobId);
        if (historyJobEntity is null) {
            throw new JobNotFoundException(historyJobId);
        }

        if (LOGGER.isDebugEnabled()) {
            LOGGER.debug("Executing historyJob {}", historyJobEntity.getId());
        }

        try {
            CommandContextUtil.getJobManager(commandContext).execute(historyJobEntity);
        } catch (Throwable exception) {
            // Finally, Throw the exception to indicate the failure
            throw new FlowableException("HistoryJob " + historyJobId + " failed", exception);
        }

        return null;
    }

}