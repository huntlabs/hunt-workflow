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

module flow.job.service.impl.asyncexecutor.FailedJobListener;

import flow.common.api.deleg.event.FlowableEngineEventType;
import flow.common.api.deleg.event.FlowableEventDispatcher;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandConfig;
import flow.common.interceptor.CommandContext;
import flow.common.interceptor.CommandContextCloseListener;
import flow.common.interceptor.CommandExecutor;
import flow.job.service.api.Job;
import flow.job.service.event.impl.FlowableJobEventBuilder;
import flow.job.service.impl.util.CommandContextUtil;
import flow.job.service.impl.asyncexecutor.FailedJobCommandFactory;
/**
 * @author Frederik Heremans
 * @author Saeid Mirzaei
 * @author Joram Barrez
 */
class FailedJobListener : CommandContextCloseListener {

    protected CommandExecutor commandExecutor;
    protected Job job;

    this(CommandExecutor commandExecutor, Job job) {
        this.commandExecutor = commandExecutor;
        this.job = job;
    }


    public void closing(CommandContext commandContext) {
    }


    public void afterSessionsFlush(CommandContext commandContext) {
    }


    public void closed(CommandContext context) {
        FlowableEventDispatcher eventDispatcher = CommandContextUtil.getEventDispatcher();
        if (eventDispatcher !is null && eventDispatcher.isEnabled()) {
            eventDispatcher.dispatchEvent(
                    FlowableJobEventBuilder.createEntityEvent(FlowableEngineEventType.JOB_EXECUTION_SUCCESS, cast(Object)job));
        }
    }


    public void closeFailure(CommandContext commandContext) {
        FlowableEventDispatcher eventDispatcher = CommandContextUtil.getEventDispatcher();
        if (eventDispatcher !is null && eventDispatcher.isEnabled()) {
            eventDispatcher.dispatchEvent(FlowableJobEventBuilder.createEntityExceptionEvent(
                    FlowableEngineEventType.JOB_EXECUTION_FAILURE, cast(Object)job, commandContext.getException()));
        }

        CommandConfig commandConfig = commandExecutor.getDefaultConfig().transactionRequiresNew();
        FailedJobCommandFactory failedJobCommandFactory = CommandContextUtil.getJobServiceConfiguration().getFailedJobCommandFactory();
        Command!Object cmd = failedJobCommandFactory.getCommand(job.getId(), commandContext.getException());


        //LOGGER.trace("Using FailedJobCommandFactory '{}' and command of type '{}'", failedJobCommandFactory.getClass(), cmd.getClass());
        commandExecutor.execute(commandConfig, cmd);
    }

}
