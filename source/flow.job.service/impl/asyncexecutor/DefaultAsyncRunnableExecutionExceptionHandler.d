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
module flow.job.service.impl.asyncexecutor.DefaultAsyncRunnableExecutionExceptionHandler;

import flow.common.api.deleg.event.FlowableEngineEventType;
import flow.common.api.deleg.event.FlowableEventDispatcher;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandConfig;
import flow.common.interceptor.CommandContext;
import flow.job.service.api.JobInfo;
import flow.job.service.InternalJobCompatibilityManager;
import flow.job.service.JobServiceConfiguration;
import flow.job.service.event.impl.FlowableJobEventBuilder;
import flow.job.service.impl.persistence.entity.AbstractRuntimeJobEntity;
import flow.job.service.impl.util.CommandContextUtil;
import flow.job.service.impl.asyncexecutor.AsyncRunnableExecutionExceptionHandler;
import flow.job.service.impl.asyncexecutor.FailedJobCommandFactory;
import hunt.Object;
/**
 * @author martin.grofcik
 */
class DefaultAsyncRunnableExecutionExceptionHandler : AsyncRunnableExecutionExceptionHandler {

    public bool handleException( JobServiceConfiguration jobServiceConfiguration,  JobInfo job,  Throwable exception) {
        jobServiceConfiguration.getCommandExecutor().execute(new class Command!Void {
            public Void execute(CommandContext commandContext) {

                // Finally, Throw the exception to indicate the ExecuteAsyncJobCmd failed
                string message = "Job " ~ job.getId() ~ " failed";
               // LOGGER.error(message, exception);
                AbstractRuntimeJobEntity runtimeJob = cast(AbstractRuntimeJobEntity) job;
                if (runtimeJob !is null) {
                    InternalJobCompatibilityManager internalJobCompatibilityManager = jobServiceConfiguration.getInternalJobCompatibilityManager();
                    if (internalJobCompatibilityManager !is null && internalJobCompatibilityManager.isFlowable5Job(runtimeJob)) {
                        internalJobCompatibilityManager.handleFailedV5Job(runtimeJob, exception);
                        return null;
                    }
                }

                CommandConfig commandConfig = jobServiceConfiguration.getCommandExecutor().getDefaultConfig().transactionRequiresNew();
                FailedJobCommandFactory failedJobCommandFactory = jobServiceConfiguration.getFailedJobCommandFactory();
                Command!Object cmd = failedJobCommandFactory.getCommand(job.getId(), exception);

                //LOGGER.trace("Using FailedJobCommandFactory '{}' and command of type '{}'", failedJobCommandFactory.getClass(), cmd.getClass());
                jobServiceConfiguration.getCommandExecutor().execute(commandConfig, cmd);

                // Dispatch an event, indicating job execution failed in a
                // try-catch block, to prevent the original exception to be swallowed
                FlowableEventDispatcher eventDispatcher = CommandContextUtil.getEventDispatcher();
                if (eventDispatcher !is null && eventDispatcher.isEnabled()) {
                    try {
                        eventDispatcher
                            .dispatchEvent(FlowableJobEventBuilder.createEntityExceptionEvent(FlowableEngineEventType.JOB_EXECUTION_FAILURE, job, exception));
                    } catch (Throwable ignore) {
                        LOGGER.warn("Exception occurred while dispatching job failure event, ignoring.", ignore);
                    }
                }

                return null;
            }

        });

        return true;
    }


}
