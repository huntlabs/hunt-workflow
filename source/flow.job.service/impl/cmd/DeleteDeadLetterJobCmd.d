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

module flow.job.service.impl.cmd.DeleteDeadLetterJobCmd;


import flow.common.api.FlowableIllegalArgumentException;
import flow.common.api.FlowableObjectNotFoundException;
import flow.common.api.deleg.event.FlowableEngineEventType;
import flow.common.api.deleg.event.FlowableEventDispatcher;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.job.service.api.Job;
import flow.job.service.event.impl.FlowableJobEventBuilder;
import flow.job.service.impl.persistence.entity.DeadLetterJobEntity;
import flow.job.service.impl.util.CommandContextUtil;
import hunt.logging;
/**
 * @author Tijs Rademakers
 */

class DeleteDeadLetterJobCmd : Command!Object {

    protected string timerJobId;

    this(string timerJobId) {
        this.timerJobId = timerJobId;
    }

    public Object execute(CommandContext commandContext) {
        DeadLetterJobEntity jobToDelete = getJobToDelete(commandContext);

        sendCancelEvent(jobToDelete);

        CommandContextUtil.getDeadLetterJobEntityManager(commandContext).dele(jobToDelete);
        return null;
    }

    protected void sendCancelEvent(DeadLetterJobEntity jobToDelete) {
        FlowableEventDispatcher eventDispatcher = CommandContextUtil.getJobServiceConfiguration().getEventDispatcher();
        if (eventDispatcher !is null && eventDispatcher.isEnabled()) {
            eventDispatcher
                .dispatchEvent(FlowableJobEventBuilder.createEntityEvent(FlowableEngineEventType.JOB_CANCELED, jobToDelete));
        }
    }

    protected DeadLetterJobEntity getJobToDelete(CommandContext commandContext) {
        if (timerJobId is null) {
            throw new FlowableIllegalArgumentException("jobId is null");
        }
        //if (LOGGER.isDebugEnabled()) {
        //    LOGGER.debug("Deleting job {}", timerJobId);
        //}
        logInfo("Deleting job {%s}",timerJobId);

        DeadLetterJobEntity job = CommandContextUtil.getDeadLetterJobEntityManager(commandContext).findById(timerJobId);
        if (job is null) {
            throw new FlowableObjectNotFoundException("No dead letter job found with id '" ~ timerJobId ~ "'");
        }

        return job;
    }

}
