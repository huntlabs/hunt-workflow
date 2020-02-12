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

import flow.common.api.FlowableIllegalArgumentException;
import flow.common.api.FlowableObjectNotFoundException;
import flow.common.api.delegate.event.FlowableEngineEventType;
import flow.common.api.delegate.event.FlowableEventDispatcher;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import org.flowable.job.api.Job;
import org.flowable.job.service.event.impl.FlowableJobEventBuilder;
import org.flowable.job.service.impl.persistence.entity.JobEntity;
import org.flowable.job.service.impl.util.CommandContextUtil;

/**
 * @author Falko Menge
 */
public class SetJobRetriesCmd implements Command<Void>, Serializable {

    private static final long serialVersionUID = 1L;

    private final string jobId;
    private final int retries;

    public SetJobRetriesCmd(string jobId, int retries) {
        if (jobId == null || jobId.length() < 1) {
            throw new FlowableIllegalArgumentException("The job id is mandatory, but '" + jobId + "' has been provided.");
        }
        if (retries < 0) {
            throw new FlowableIllegalArgumentException("The number of job retries must be a non-negative Integer, but '" + retries + "' has been provided.");
        }
        this.jobId = jobId;
        this.retries = retries;
    }

    @Override
    public Void execute(CommandContext commandContext) {
        JobEntity job = CommandContextUtil.getJobEntityManager(commandContext).findById(jobId);
        if (job != null) {

            job.setRetries(retries);

            FlowableEventDispatcher eventDispatcher = CommandContextUtil.getEventDispatcher(commandContext);
            if (eventDispatcher != null && eventDispatcher.isEnabled()) {
                eventDispatcher.dispatchEvent(FlowableJobEventBuilder.createEntityEvent(FlowableEngineEventType.ENTITY_UPDATED, job));
            }
        } else {
            throw new FlowableObjectNotFoundException("No job found with id '" + jobId + "'.", Job.class);
        }
        return null;
    }
}
