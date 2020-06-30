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

module flow.engine.impl.bpmn.helper.ScopeUtil;

import hunt.collection.ArrayList;
import hunt.collection.Collections;
//import java.util.Comparator;
import hunt.collection.List;
import hunt.collection.Map;

//import flow.common.util.CollectionUtil;
import flow.engine.deleg.DelegateExecution;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.persistence.entity.ExecutionEntityManager;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.impl.util.CountingEntityUtil;
import flow.engine.impl.util.EventSubscriptionUtil;
import flow.eventsubscription.service.EventSubscriptionService;
import flow.eventsubscription.service.impl.persistence.entity.CompensateEventSubscriptionEntity;
import flow.eventsubscription.service.impl.persistence.entity.EventSubscriptionEntity;
import hunt.util.Comparator;
import hunt.Exceptions;
/**
 * @author Tijs Rademakers
 * @author Joram Barrez
 */
class ScopeUtil {

    /**
     * we create a separate execution for each compensation handler invocation.
     */
    public static void throwCompensationEvent(List!CompensateEventSubscriptionEntity eventSubscriptions, DelegateExecution execution, bool async) {

        ExecutionEntityManager executionEntityManager = CommandContextUtil.getExecutionEntityManager();

        // first spawn the compensating executions
        foreach (CompensateEventSubscriptionEntity eventSubscription ; eventSubscriptions) {
            ExecutionEntity compensatingExecution = null;

            // check whether compensating execution is already created (which is the case when compensating an embedded subprocess,
            // where the compensating execution is created when leaving the subprocess and holds snapshot data).
            if ((cast(EventSubscriptionEntity)eventSubscription).getConfiguration() !is null) {
                compensatingExecution = executionEntityManager.findById((cast(EventSubscriptionEntity)eventSubscription).getConfiguration());
                compensatingExecution.setParent(compensatingExecution.getProcessInstance());
                compensatingExecution.setEventScope(false);
            } else {
                compensatingExecution = executionEntityManager.createChildExecution(cast(ExecutionEntity) execution);
                (cast(EventSubscriptionEntity)eventSubscription).setConfiguration(compensatingExecution.getId());
            }

        }

        implementationMissing(false);
        // signal compensation events in reverse order of their 'created' timestamp
        //eventSubscriptions.sort(new class Comparator!EventSubscriptionEntity {
        //      public int compare(EventSubscriptionEntity o1, EventSubscriptionEntity o2) {
        //          return cast(int)(o2.getCreated().toEpochMilli - o1.getCreated().toEpochMilli);
        //      }
        //});
        //Collections.sort(eventSubscriptions, new Comparator!EventSubscriptionEntity() {
        //    override
        //    public int compare(EventSubscriptionEntity o1, EventSubscriptionEntity o2) {
        //        return o2.getCreated().compareTo(o1.getCreated());
        //    }
        //});

        foreach (CompensateEventSubscriptionEntity compensateEventSubscriptionEntity ; eventSubscriptions) {
            EventSubscriptionUtil.eventReceived(compensateEventSubscriptionEntity, null, async);
        }
    }

    /**
     * Creates a new event scope execution and moves existing event subscriptions to this new execution
     */
    public static void createCopyOfSubProcessExecutionForCompensation(ExecutionEntity subProcessExecution) {
        EventSubscriptionService eventSubscriptionService = CommandContextUtil.getEventSubscriptionService();
        List!EventSubscriptionEntity eventSubscriptions = eventSubscriptionService.findEventSubscriptionsByExecutionAndType(subProcessExecution.getId(), "compensate");

        List!CompensateEventSubscriptionEntity compensateEventSubscriptions = new ArrayList!CompensateEventSubscriptionEntity();
        foreach (EventSubscriptionEntity event ; eventSubscriptions) {
            if (cast(CompensateEventSubscriptionEntity)event !is null) {
                compensateEventSubscriptions.add(cast(CompensateEventSubscriptionEntity) event);
            }
        }

        if (compensateEventSubscriptions !is null && compensateEventSubscriptions.size() != 0) {

            ExecutionEntity processInstanceExecutionEntity = subProcessExecution.getProcessInstance();

            ExecutionEntity eventScopeExecution = CommandContextUtil.getExecutionEntityManager().createChildExecution(processInstanceExecutionEntity);
            eventScopeExecution.setActive(false);
            eventScopeExecution.setEventScope(true);
            eventScopeExecution.setCurrentFlowElement(subProcessExecution.getCurrentFlowElement());

            // copy local variables to eventScopeExecution by value. This way,
            // the eventScopeExecution references a 'snapshot' of the local variables
            Map!(string, Object) variables = subProcessExecution.getVariablesLocal();
            foreach (MapEntry!(string, Object) variable ; variables) {
                eventScopeExecution.setVariableLocal(variable.getKey(), variable.getValue(), subProcessExecution, true);
            }

            // set event subscriptions to the event scope execution:
            foreach (CompensateEventSubscriptionEntity eventSubscriptionEntity ; compensateEventSubscriptions) {
                eventSubscriptionService.deleteEventSubscription(eventSubscriptionEntity);
                CountingEntityUtil.handleDeleteEventSubscriptionEntityCount(eventSubscriptionEntity);

                EventSubscriptionEntity newSubscription = cast(EventSubscriptionEntity) eventSubscriptionService.createEventSubscriptionBuilder()
                                .eventType(CompensateEventSubscriptionEntity.EVENT_TYPE)
                                .executionId(eventScopeExecution.getId())
                                .processInstanceId(eventScopeExecution.getProcessInstanceId())
                                .activityId(eventSubscriptionEntity.getActivityId())
                                .tenantId(eventScopeExecution.getTenantId())
                                .create();

                CountingEntityUtil.handleInsertEventSubscriptionEntityCount(newSubscription);

                newSubscription.setConfiguration(eventSubscriptionEntity.getConfiguration());
                newSubscription.setCreated(eventSubscriptionEntity.getCreated());
            }

            EventSubscriptionEntity eventSubscription = cast(EventSubscriptionEntity) eventSubscriptionService.createEventSubscriptionBuilder()
                            .eventType(CompensateEventSubscriptionEntity.EVENT_TYPE)
                            .executionId(processInstanceExecutionEntity.getId())
                            .processInstanceId(processInstanceExecutionEntity.getProcessInstanceId())
                            .activityId(eventScopeExecution.getCurrentFlowElement().getId())
                            .tenantId(processInstanceExecutionEntity.getTenantId())
                            .create();

            CountingEntityUtil.handleInsertEventSubscriptionEntityCount(eventSubscription);

            eventSubscription.setConfiguration(eventScopeExecution.getId());
        }
    }
}
