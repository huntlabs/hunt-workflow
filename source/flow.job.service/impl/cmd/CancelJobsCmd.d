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



import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import flow.common.api.delegate.event.FlowableEngineEventType;
import flow.common.api.delegate.event.FlowableEventDispatcher;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import org.flowable.job.service.event.impl.FlowableJobEventBuilder;
import org.flowable.job.service.impl.persistence.entity.JobEntity;
import org.flowable.job.service.impl.persistence.entity.TimerJobEntity;
import org.flowable.job.service.impl.util.CommandContextUtil;

/**
 * Send job cancelled event and delete job
 * 
 * @author Tom Baeyens
 */
public class CancelJobsCmd implements Command<Void>, Serializable {

    private static final long serialVersionUID = 1L;
    List<string> jobIds;

    public CancelJobsCmd(List<string> jobIds) {
        this.jobIds = jobIds;
    }

    public CancelJobsCmd(string jobId) {
        this.jobIds = new ArrayList<>();
        jobIds.add(jobId);
    }

    @Override
    public Void execute(CommandContext commandContext) {
        JobEntity jobToDelete = null;
        for (string jobId : jobIds) {
            jobToDelete = CommandContextUtil.getJobEntityManager(commandContext).findById(jobId);

            FlowableEventDispatcher eventDispatcher = CommandContextUtil.getEventDispatcher(commandContext);
            if (jobToDelete != null) {
                // When given job doesn't exist, ignore
                if (eventDispatcher != null && eventDispatcher.isEnabled()) {
                    eventDispatcher
                        .dispatchEvent(FlowableJobEventBuilder.createEntityEvent(FlowableEngineEventType.JOB_CANCELED, jobToDelete));
                }

                CommandContextUtil.getJobEntityManager(commandContext).delete(jobToDelete);

            } else {
                TimerJobEntity timerJobToDelete = CommandContextUtil.getTimerJobEntityManager(commandContext).findById(jobId);

                if (timerJobToDelete != null) {
                    // When given job doesn't exist, ignore
                    if (eventDispatcher != null && eventDispatcher.isEnabled()) {
                        eventDispatcher
                            .dispatchEvent(FlowableJobEventBuilder.createEntityEvent(FlowableEngineEventType.JOB_CANCELED, timerJobToDelete));
                    }

                    CommandContextUtil.getTimerJobEntityManager(commandContext).delete(timerJobToDelete);
                }
            }
        }
        return null;
    }
}
