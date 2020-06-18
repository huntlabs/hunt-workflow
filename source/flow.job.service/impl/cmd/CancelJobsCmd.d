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

module flow.job.service.impl.cmd.CancelJobsCmd;

import hunt.collection.ArrayList;
import hunt.collection.List;

import flow.common.api.deleg.event.FlowableEngineEventType;
import flow.common.api.deleg.event.FlowableEventDispatcher;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.job.service.event.impl.FlowableJobEventBuilder;
import flow.job.service.impl.persistence.entity.JobEntity;
import flow.job.service.impl.persistence.entity.TimerJobEntity;
import flow.job.service.impl.util.CommandContextUtil;
import hunt.Object;

/**
 * Send job cancelled event and delete job
 *
 * @author Tom Baeyens
 */
class CancelJobsCmd : Command!Void {

    List!string jobIds;

    this(List!string jobIds) {
        this.jobIds = jobIds;
    }

    this(string jobId) {
        this.jobIds = new ArrayList!string();
        jobIds.add(jobId);
    }

    public Void execute(CommandContext commandContext) {
        JobEntity jobToDelete = null;
        foreach (string jobId ; jobIds) {
            jobToDelete = CommandContextUtil.getJobEntityManager(commandContext).findById(jobId);

            FlowableEventDispatcher eventDispatcher = CommandContextUtil.getEventDispatcher(commandContext);
            if (jobToDelete !is null) {
                // When given job doesn't exist, ignore
                if (eventDispatcher !is null && eventDispatcher.isEnabled()) {
                    eventDispatcher
                        .dispatchEvent(FlowableJobEventBuilder.createEntityEvent(FlowableEngineEventType.JOB_CANCELED, jobToDelete));
                }

                CommandContextUtil.getJobEntityManager(commandContext).dele(jobToDelete);

            } else {
                TimerJobEntity timerJobToDelete = CommandContextUtil.getTimerJobEntityManager(commandContext).findById(jobId);

                if (timerJobToDelete !is null) {
                    // When given job doesn't exist, ignore
                    if (eventDispatcher !is null && eventDispatcher.isEnabled()) {
                        eventDispatcher
                            .dispatchEvent(FlowableJobEventBuilder.createEntityEvent(FlowableEngineEventType.JOB_CANCELED, timerJobToDelete));
                    }

                    CommandContextUtil.getTimerJobEntityManager(commandContext).dele(timerJobToDelete);
                }
            }
        }
        return null;
    }
}
