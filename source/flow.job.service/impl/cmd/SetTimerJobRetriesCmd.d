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

module flow.job.service.impl.cmd.SetTimerJobRetriesCmd;


import flow.common.api.FlowableIllegalArgumentException;
import flow.common.api.FlowableObjectNotFoundException;
import flow.common.api.deleg.event.FlowableEngineEventType;
import flow.common.api.deleg.event.FlowableEventDispatcher;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.job.service.api.Job;
import flow.job.service.event.impl.FlowableJobEventBuilder;
import flow.job.service.impl.persistence.entity.TimerJobEntity;
import flow.job.service.impl.util.CommandContextUtil;
import hunt.Object;
import hunt.logging;
/**
 * @author Tijs Rademakers
 */
class SetTimerJobRetriesCmd : Command!Void {

    private  string jobId;
    private  int retries;

    this(string jobId, int retries) {
        if (jobId is null || jobId.length() < 1) {
            throw new FlowableIllegalArgumentException("The job id is mandatory, but '" ~ jobId ~ "' has been provided.");
        }
        if (retries < 0) {
            throw new FlowableIllegalArgumentException("The number of job retries must be a non-negative Integer, but '" ~ retries ~ "' has been provided.");
        }
        this.jobId = jobId;
        this.retries = retries;
    }

    public Void execute(CommandContext commandContext) {
        TimerJobEntity job = CommandContextUtil.getTimerJobEntityManager(commandContext).findById(jobId);
        if (job !is null) {

            job.setRetries(retries);

            FlowableEventDispatcher eventDispatcher = CommandContextUtil.getEventDispatcher(commandContext);
            if (eventDispatcher !is null && eventDispatcher.isEnabled()) {
                eventDispatcher.dispatchEvent(FlowableJobEventBuilder.createEntityEvent(FlowableEngineEventType.ENTITY_UPDATED, job));
            }
        } else {
            throw new FlowableObjectNotFoundException("No timer job found with id '" ~ jobId ~ "'.");
        }
        return null;
    }
}
