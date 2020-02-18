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


import org.flowable.bpmn.model.BoundaryEvent;
import org.flowable.bpmn.model.FlowElement;
import org.flowable.bpmn.model.FlowNode;
import org.flowable.bpmn.model.ServiceTask;
import flow.common.api.FlowableException;
import flow.common.interceptor.CommandContext;
import flow.engine.impl.delegate.ActivityBehavior;
import flow.engine.impl.delegate.TriggerableActivityBehavior;
import flow.engine.impl.jobexecutor.AsyncTriggerJobHandler;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.util.CommandContextUtil;
import org.flowable.job.service.JobService;
import org.flowable.job.service.impl.persistence.entity.JobEntity;

/**
 * Operation that triggers a wait state and continues the process, leaving that activity.
 * 
 * The {@link ExecutionEntity} for this operations should be in a wait state (receive task for example) and have a {@link FlowElement} that has a behaviour that implements the
 * {@link TriggerableActivityBehavior}.
 * 
 * @author Joram Barrez
 */
class TriggerExecutionOperation extends AbstractOperation {
    
    protected bool triggerAsync;

    public TriggerExecutionOperation(CommandContext commandContext, ExecutionEntity execution) {
        super(commandContext, execution);
    }

    public TriggerExecutionOperation(CommandContext commandContext, ExecutionEntity execution, bool triggerAsync) {
        super(commandContext, execution);
        this.triggerAsync = triggerAsync;
    }

    @Override
    public void run() {
        FlowElement currentFlowElement = getCurrentFlowElement(execution);
        if (currentFlowElement instanceof FlowNode) {

            ActivityBehavior activityBehavior = (ActivityBehavior) ((FlowNode) currentFlowElement).getBehavior();
            if (activityBehavior instanceof TriggerableActivityBehavior) {

                if (currentFlowElement instanceof BoundaryEvent
                        || currentFlowElement instanceof ServiceTask) { // custom service task with no automatic leave (will not have a activity-start history entry in ContinueProcessOperation)
                    
                    CommandContextUtil.getActivityInstanceEntityManager(commandContext).recordActivityStart(execution);
                }

                if (!triggerAsync) {
                    ((TriggerableActivityBehavior) activityBehavior).trigger(execution, null, null);
                    
                } else {
                    JobService jobService = CommandContextUtil.getJobService();
                    JobEntity job = jobService.createJob();
                    job.setExecutionId(execution.getId());
                    job.setProcessInstanceId(execution.getProcessInstanceId());
                    job.setProcessDefinitionId(execution.getProcessDefinitionId());
                    job.setElementId(currentFlowElement.getId());
                    job.setElementName(currentFlowElement.getName());
                    job.setJobHandlerType(AsyncTriggerJobHandler.TYPE);
                    
                    // Inherit tenant id (if applicable)
                    if(execution.getTenantId() !is null) {
                        job.setTenantId(execution.getTenantId());
                    }

                    jobService.createAsyncJob(job, true);
                    jobService.scheduleAsyncJob(job);
                }


            } else {
                throw new FlowableException("Cannot trigger execution with id " + execution.getId()
                    + " : the activityBehavior " + activityBehavior.getClass() + " does not implement the "
                    + TriggerableActivityBehavior.class.getName() + " interface");

            }

        } else if (currentFlowElement is null) {
            throw new FlowableException("Cannot trigger execution with id " + execution.getId()
                    + " : no current flow element found. Check the execution id that is being passed "
                    + "(it should not be a process instance execution, but a child execution currently referencing a flow element).");

        } else {
            throw new FlowableException("Programmatic error: cannot trigger execution, invalid flowelement type found: "
                    + currentFlowElement.getClass().getName() + ".");

        }
    }

}
