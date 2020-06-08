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



import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.engine.compatibility.Flowable5CompatibilityHandler;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.impl.util.Flowable5Util;
import flow.job.service.api.Job;
import flow.job.service.InternalJobCompatibilityManager;
import flow.job.service.impl.persistence.entity.AbstractRuntimeJobEntity;

/**
 * @author Tijs Rademakers
 * @author Joram Barrez
 */
class DefaultInternalJobCompatibilityManager implements InternalJobCompatibilityManager {

    protected ProcessEngineConfigurationImpl processEngineConfiguration;

    public DefaultInternalJobCompatibilityManager(ProcessEngineConfigurationImpl processEngineConfiguration) {
        this.processEngineConfiguration = processEngineConfiguration;
    }

    override
    public bool isFlowable5Job(Job job) {
        if (job.getProcessDefinitionId() !is null) {
            return Flowable5Util.isFlowable5ProcessDefinitionId(processEngineConfiguration, job.getProcessDefinitionId());
        }
        return false;
    }

    override
    public void executeV5Job(Job job) {
        Flowable5CompatibilityHandler compatibilityHandler = Flowable5Util.getFlowable5CompatibilityHandler();
        compatibilityHandler.executeJob(job);
    }

    override
    public void executeV5JobWithLockAndRetry(final Job job) {

        // Retrieving the compatibility handler needs to be done outside of the executeJobWithLockAndRetry call,
        // as it shouldn't be wrapped in a transaction.
        Flowable5CompatibilityHandler compatibilityHandler = processEngineConfiguration.getCommandExecutor().execute(new Command!Flowable5CompatibilityHandler() {

            override
            public Flowable5CompatibilityHandler execute(CommandContext commandContext) {
                return CommandContextUtil.getProcessEngineConfiguration(commandContext).getFlowable5CompatibilityHandler();
            }
        });

        // Note: no transaction (on purpose)
        compatibilityHandler.executeJobWithLockAndRetry(job);
    }

    override
    public void deleteV5Job(string jobId) {
        Flowable5CompatibilityHandler compatibilityHandler = Flowable5Util.getFlowable5CompatibilityHandler();
        compatibilityHandler.deleteJob(jobId);
    }

    override
    public void handleFailedV5Job(AbstractRuntimeJobEntity job, Throwable exception) {
        Flowable5CompatibilityHandler compatibilityHandler = Flowable5Util.getFlowable5CompatibilityHandler();
        compatibilityHandler.handleFailedJob(job, exception);
    }

}
