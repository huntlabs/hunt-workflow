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


import flow.bpmn.model.FlowElement;
import flow.bpmn.model.FlowNode;
import flow.common.api.FlowableException;
import flow.common.api.deleg.event.FlowableEngineEventType;
import flow.common.api.deleg.event.FlowableEventDispatcher;
import flow.common.interceptor.CommandContext;
import flow.common.util.CollectionUtil;
import flow.engine.deleg.BpmnError;
import flow.engine.deleg.ExecutionListener;
import flow.engine.deleg.event.impl.FlowableEventBuilder;
import flow.engine.impl.bpmn.behavior.MultiInstanceActivityBehavior;
import flow.engine.impl.bpmn.helper.ErrorPropagation;
import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
import flow.engine.impl.delegate.ActivityBehavior;
import flow.engine.impl.jobexecutor.AsyncContinuationJobHandler;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.logging.LogMDC;
import org.flowable.job.service.JobService;
import org.flowable.job.service.impl.persistence.entity.JobEntity;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Special operation when executing an instance of a multi-instance. It's similar to the {@link ContinueProcessOperation}, but simpler, as it doesn't need to cater for as many use cases.
 *
 * @author Joram Barrez
 * @author Tijs Rademakers
 */
class ContinueMultiInstanceOperation extends AbstractOperation {

    private static final Logger LOGGER = LoggerFactory.getLogger(ContinueMultiInstanceOperation.class);

    protected ExecutionEntity multiInstanceRootExecution;
    protected int loopCounter;

    public ContinueMultiInstanceOperation(CommandContext commandContext, ExecutionEntity execution, ExecutionEntity multiInstanceRootExecution, int loopCounter) {
        super(commandContext, execution);
        this.multiInstanceRootExecution = multiInstanceRootExecution;
        this.loopCounter = loopCounter;
    }

    @Override
    public void run() {
        FlowElement currentFlowElement = getCurrentFlowElement(execution);
        if (currentFlowElement instanceof FlowNode) {
            continueThroughMultiInstanceFlowNode((FlowNode) currentFlowElement);
        } else {
            throw new RuntimeException("Programmatic error: no valid multi instance flow node, type: " + currentFlowElement + ". Halting.");
        }
    }

    protected void continueThroughMultiInstanceFlowNode(FlowNode flowNode) {
        setLoopCounterVariable(flowNode);
        if (!flowNode.isAsynchronous()) {
            executeSynchronous(flowNode);
        } else {
            executeAsynchronous(flowNode);
        }
    }

    protected void executeSynchronous(FlowNode flowNode) {
        CommandContextUtil.getActivityInstanceEntityManager(commandContext).recordActivityStart(execution);

        // Execution listener
        if (CollectionUtil.isNotEmpty(flowNode.getExecutionListeners())) {
            executeExecutionListeners(flowNode, ExecutionListener.EVENTNAME_START);
        }

        // Execute actual behavior
        ActivityBehavior activityBehavior = (ActivityBehavior) flowNode.getBehavior();
        LOGGER.debug("Executing activityBehavior {} on activity '{}' with execution {}", activityBehavior.getClass(), flowNode.getId(), execution.getId());

        ProcessEngineConfigurationImpl processEngineConfiguration = CommandContextUtil.getProcessEngineConfiguration(commandContext);
        FlowableEventDispatcher eventDispatcher = null;
        if (processEngineConfiguration !is null) {
            eventDispatcher = processEngineConfiguration.getEventDispatcher();
        }
        if (eventDispatcher !is null && eventDispatcher.isEnabled()) {
            processEngineConfiguration.getEventDispatcher().dispatchEvent(
                    FlowableEventBuilder.createActivityEvent(FlowableEngineEventType.ACTIVITY_STARTED, flowNode.getId(), flowNode.getName(), execution.getId(),
                            execution.getProcessInstanceId(), execution.getProcessDefinitionId(), flowNode));
        }

        try {
            activityBehavior.execute(execution);
        } catch (BpmnError error) {
            // re-throw business fault so that it can be caught by an Error Intermediate Event or Error Event Sub-Process in the process
            ErrorPropagation.propagateError(error, execution);
        } catch (RuntimeException e) {
            if (LogMDC.isMDCEnabled()) {
                LogMDC.putMDCExecution(execution);
            }
            throw e;
        }
    }

    protected void executeAsynchronous(FlowNode flowNode) {
        JobService jobService = CommandContextUtil.getJobService(commandContext);

        JobEntity job = jobService.createJob();
        job.setExecutionId(execution.getId());
        job.setProcessInstanceId(execution.getProcessInstanceId());
        job.setProcessDefinitionId(execution.getProcessDefinitionId());
        job.setElementId(flowNode.getId());
        job.setElementName(flowNode.getName());
        job.setJobHandlerType(AsyncContinuationJobHandler.TYPE);

        // Inherit tenant id (if applicable)
        if (execution.getTenantId() !is null) {
            job.setTenantId(execution.getTenantId());
        }

        execution.getJobs().add(job);

        jobService.createAsyncJob(job, flowNode.isExclusive());
        jobService.scheduleAsyncJob(job);
    }

    protected ActivityBehavior setLoopCounterVariable(FlowNode flowNode) {
        ActivityBehavior activityBehavior = (ActivityBehavior) flowNode.getBehavior();
        if (!(activityBehavior instanceof MultiInstanceActivityBehavior)) {
            throw new FlowableException("Programmatic error: expected multi instance activity behavior, but got " + activityBehavior.getClass());
        }
        MultiInstanceActivityBehavior multiInstanceActivityBehavior = (MultiInstanceActivityBehavior) activityBehavior;
        string elementIndexVariable = multiInstanceActivityBehavior.getCollectionElementIndexVariable();
        if (!flowNode.isAsynchronous()) {
            execution.setVariableLocal(elementIndexVariable, loopCounter);
        } else {
            multiInstanceRootExecution.setVariableLocal(elementIndexVariable, loopCounter);
        }
        return activityBehavior;
    }

}
