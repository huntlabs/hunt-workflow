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
module flow.engine.impl.jobexecutor.ProcessEventJobHandler;


import flow.common.interceptor.CommandContext;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.impl.util.EventSubscriptionUtil;
import flow.eventsubscription.service.EventSubscriptionService;
import flow.eventsubscription.service.impl.persistence.entity.EventSubscriptionEntity;
import flow.job.service.JobHandler;
import flow.job.service.impl.persistence.entity.JobEntity;
import flow.variable.service.api.deleg.VariableScope;

/**
 * @author Daniel Meyer
 * @author Joram Barrez
 */
class ProcessEventJobHandler : JobHandler {

    public static  string TYPE = "event";

    public string getType() {
        return TYPE;
    }

    public void execute(JobEntity job, string configuration, VariableScope variableScope, CommandContext commandContext) {

        EventSubscriptionService eventSubscriptionService = CommandContextUtil.getEventSubscriptionService(commandContext);

        // lookup subscription:
        EventSubscriptionEntity eventSubscriptionEntity = eventSubscriptionService.findById(configuration);

        // if event subscription is null, ignore
        if (eventSubscriptionEntity !is null) {
            EventSubscriptionUtil.eventReceived(eventSubscriptionEntity, null, false);
        }

    }

}
