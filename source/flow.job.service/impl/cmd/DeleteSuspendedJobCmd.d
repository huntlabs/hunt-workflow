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
module flow.job.service.impl.cmd.DeleteSuspendedJobCmd;


import flow.common.api.FlowableIllegalArgumentException;
import flow.common.api.FlowableObjectNotFoundException;
import flow.common.api.deleg.event.FlowableEngineEventType;
import flow.common.api.deleg.event.FlowableEventDispatcher;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.job.service.api.Job;
import flow.job.service.event.impl.FlowableJobEventBuilder;
import flow.job.service.impl.persistence.entity.SuspendedJobEntity;
import flow.job.service.impl.util.CommandContextUtil;
import hunt.logging;
/**
 * @author Tijs Rademakers
 */

class DeleteSuspendedJobCmd : Command!Object {

    protected string suspendedJobId;

    this(string suspendedJobId) {
        this.suspendedJobId = suspendedJobId;
    }

    public Object execute(CommandContext commandContext) {
        SuspendedJobEntity jobToDelete = getJobToDelete(commandContext);

        sendCancelEvent(jobToDelete);

        CommandContextUtil.getSuspendedJobEntityManager(commandContext).dele(jobToDelete);
        return null;
    }

    protected void sendCancelEvent(SuspendedJobEntity jobToDelete) {
        FlowableEventDispatcher eventDispatcher = CommandContextUtil.getJobServiceConfiguration().getEventDispatcher();
        if (eventDispatcher !is null && eventDispatcher.isEnabled()) {
            eventDispatcher
                .dispatchEvent(FlowableJobEventBuilder.createEntityEvent(FlowableEngineEventType.JOB_CANCELED, cast(Object)jobToDelete));
        }
    }

    protected SuspendedJobEntity getJobToDelete(CommandContext commandContext) {
        if (suspendedJobId is null) {
            throw new FlowableIllegalArgumentException("jobId is null");
        }
        //if (LOGGER.isDebugEnabled()) {
        //    LOGGER.debug("Deleting job {}", suspendedJobId);
        //}
        logInfo("Deleting job {%s}",suspendedJobId);
        SuspendedJobEntity job = CommandContextUtil.getSuspendedJobEntityManager(commandContext).findById(suspendedJobId);
        if (job is null) {
            throw new FlowableObjectNotFoundException("No suspended job found with id '" ~ suspendedJobId ~ "'");
        }

        return job;
    }

}
