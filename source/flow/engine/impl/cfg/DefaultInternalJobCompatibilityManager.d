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

module flow.engine.impl.cfg.DefaultInternalJobCompatibilityManager;


import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.engine.compatibility.Flowable5CompatibilityHandler;
import flow.engine.impl.util.CommandContextUtil;
//import flow.engine.impl.util.Flowable5Util;
import flow.job.service.api.Job;
import flow.job.service.InternalJobCompatibilityManager;
import flow.job.service.impl.persistence.entity.AbstractRuntimeJobEntity;
import hunt.Exceptions;
/**
 * @author Tijs Rademakers
 * @author Joram Barrez
 */
class DefaultInternalJobCompatibilityManager : InternalJobCompatibilityManager {

    protected ProcessEngineConfigurationImpl processEngineConfiguration;

    this(ProcessEngineConfigurationImpl processEngineConfiguration) {
        this.processEngineConfiguration = processEngineConfiguration;
    }


    public bool isFlowable5Job(Job job) {
        if (job.getProcessDefinitionId() !is null) {
            implementationMissing(false);
            return false;
          //  return Flowable5Util.isFlowable5ProcessDefinitionId(processEngineConfiguration, job.getProcessDefinitionId());
        }
        return false;
    }


    public void executeV5Job(Job job) {
        implementationMissing(false);
        //Flowable5CompatibilityHandler compatibilityHandler = Flowable5Util.getFlowable5CompatibilityHandler();
        //compatibilityHandler.executeJob(job);
    }


    public void executeV5JobWithLockAndRetry( Job job) {
        implementationMissing(false);
        // Retrieving the compatibility handler needs to be done outside of the executeJobWithLockAndRetry call,
        // as it shouldn't be wrapped in a transaction.
        //Flowable5CompatibilityHandler compatibilityHandler = processEngineConfiguration.getCommandExecutor().execute(new Command!Flowable5CompatibilityHandler() {
        //
        //
        //    public Flowable5CompatibilityHandler execute(CommandContext commandContext) {
        //        return CommandContextUtil.getProcessEngineConfiguration(commandContext).getFlowable5CompatibilityHandler();
        //    }
        //});
        //
        //// Note: no transaction (on purpose)
        //compatibilityHandler.executeJobWithLockAndRetry(job);
    }


    public void deleteV5Job(string jobId) {
        implementationMissing(false);
        //Flowable5CompatibilityHandler compatibilityHandler = Flowable5Util.getFlowable5CompatibilityHandler();
        //compatibilityHandler.deleteJob(jobId);
    }


    public void handleFailedV5Job(AbstractRuntimeJobEntity job, Throwable exception) {
        implementationMissing(false);
        //Flowable5CompatibilityHandler compatibilityHandler = Flowable5Util.getFlowable5CompatibilityHandler();
        //compatibilityHandler.handleFailedJob(job, exception);
    }

}
