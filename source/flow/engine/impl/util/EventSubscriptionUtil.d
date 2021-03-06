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
module flow.engine.impl.util.EventSubscriptionUtil;

import flow.common.api.FlowableException;
import flow.engine.impl.event.EventHandler;
import flow.engine.impl.jobexecutor.ProcessEventJobHandler;
import flow.eventsubscription.service.impl.persistence.entity.CompensateEventSubscriptionEntity;
import flow.eventsubscription.service.impl.persistence.entity.EventSubscriptionEntity;
import flow.job.service.JobService;
import flow.job.service.impl.persistence.entity.JobEntity;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.impl.util.CountingEntityUtil;

class EventSubscriptionUtil {

    public static void eventReceived(EventSubscriptionEntity eventSubscriptionEntity, Object payload, bool processASync) {
        if (processASync) {
            scheduleEventAsync(eventSubscriptionEntity, payload);
        } else {
            processEventSync(eventSubscriptionEntity, payload);
        }
    }

    protected static void processEventSync(EventSubscriptionEntity eventSubscriptionEntity, Object payload) {

        // A compensate event needs to be deleted before the handlers are called
        if (cast(CompensateEventSubscriptionEntity)eventSubscriptionEntity !is null) {
            CommandContextUtil.getEventSubscriptionService().deleteEventSubscription(eventSubscriptionEntity);
            CountingEntityUtil.handleDeleteEventSubscriptionEntityCount(eventSubscriptionEntity);
        }

        EventHandler eventHandler = CommandContextUtil.getProcessEngineConfiguration().getEventHandler(eventSubscriptionEntity.getEventType());
        if (eventHandler is null) {
            throw new FlowableException("Could not find eventhandler for event of type '" ~ eventSubscriptionEntity.getEventType() ~ "'.");
        }
        eventHandler.handleEvent(eventSubscriptionEntity, payload, CommandContextUtil.getCommandContext());
    }

    protected static void scheduleEventAsync(EventSubscriptionEntity eventSubscriptionEntity, Object payload) {
        JobService jobService = CommandContextUtil.getJobService();
        JobEntity message = jobService.createJob();
        message.setJobType(JobEntity.JOB_TYPE_MESSAGE);
        message.setJobHandlerType(ProcessEventJobHandler.TYPE);
        message.setElementId(eventSubscriptionEntity.getActivityId());
        message.setJobHandlerConfiguration(eventSubscriptionEntity.getId());
        message.setTenantId(eventSubscriptionEntity.getTenantId());

        // TODO: support payload
        // if(payload !is null) {
        // message.setEventPayload(payload);
        // }

        jobService.scheduleAsyncJob(message);
    }
}
