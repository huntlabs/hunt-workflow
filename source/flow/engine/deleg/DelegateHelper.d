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
//          Copyright linse 2020.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)}

module flow.engine.deleg.DelegateHelper;





import hunt.collection.ArrayList;
import hunt.collection.List;
import hunt.collection.Map;

import flow.bpmn.model.BpmnModel;
import flow.bpmn.model.ExtensionElement;
import flow.bpmn.model.FieldExtension;
import flow.bpmn.model.FlowElement;
import flow.bpmn.model.FlowableListener;
import flow.bpmn.model.SequenceFlow;
import flow.bpmn.model.TaskWithFieldExtensions;
import flow.bpmn.model.UserTask;
import flow.common.api.FlowableException;
import flow.common.api.deleg.Expression;
import flow.common.el.ExpressionManager;
import flow.engine.impl.deleg.ActivityBehavior;
import flow.engine.impl.el.FixedValue;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.impl.util.ProcessDefinitionUtil;
import flow.task.service.deleg.DelegateTask;
import flow.engine.deleg.DelegateExecution;
import flow.bpmn.model.Process;
import hunt.String;
/**
 * Class that provides helper operations for use in the {@link JavaDelegate}, {@link ActivityBehavior}, {@link ExecutionListener} and {@link TaskListener} interfaces.
 *
 * @author Joram Barrez
 */
class DelegateHelper {

    /**
     * To be used in an {@link ActivityBehavior} or {@link JavaDelegate}: leaves according to the default BPMN 2.0 rules: all sequenceflow with a condition that evaluates to true are followed.
     */
    public static void leaveDelegate(DelegateExecution delegateExecution) {
        CommandContextUtil.getAgenda().planTakeOutgoingSequenceFlowsOperation(cast(ExecutionEntity) delegateExecution, true);
    }

    /**
     * To be used in an {@link ActivityBehavior} or {@link JavaDelegate}: leaves the current activity via one specific sequenceflow.
     */
    public static void leaveDelegate(DelegateExecution delegateExecution, string sequenceFlowId) {
        string processDefinitionId = delegateExecution.getProcessDefinitionId();
        flow.bpmn.model.Process.Process process = ProcessDefinitionUtil.getProcess(processDefinitionId);
        FlowElement flowElement = process.getFlowElement(sequenceFlowId);
        if (cast(SequenceFlow)flowElement !is null) {
            delegateExecution.setCurrentFlowElement(flowElement);
            CommandContextUtil.getAgenda().planTakeOutgoingSequenceFlowsOperation(cast(ExecutionEntity) delegateExecution, false);
        } else {
            throw new FlowableException(sequenceFlowId ~ " does not match a sequence flow");
        }
    }

    /**
     * Returns the {@link BpmnModel} matching the process definition bpmn model for the process definition of the passed {@link DelegateExecution}.
     */
    public static BpmnModel getBpmnModel(DelegateExecution execution) {
        if (execution is null) {
            throw new FlowableException("Null execution passed");
        }
        return ProcessDefinitionUtil.getBpmnModel(execution.getProcessDefinitionId());
    }

    /**
     * Returns the current {@link FlowElement} where the {@link DelegateExecution} is currently at.
     */
    public static FlowElement getFlowElement(DelegateExecution execution) {
        BpmnModel bpmnModel = getBpmnModel(execution);
        FlowElement flowElement = bpmnModel.getFlowElement(execution.getCurrentActivityId());
        if (flowElement is null) {
            throw new FlowableException("Could not find a FlowElement for activityId " ~ execution.getCurrentActivityId());
        }
        return flowElement;
    }

    /**
     * Returns whether or not the provided execution is being use for executing an {@link ExecutionListener}.
     */
    public static bool isExecutingExecutionListener(DelegateExecution execution) {
        return execution.getCurrentFlowableListener() !is null;
    }

    /**
     * Returns for the activityId of the passed {@link DelegateExecution} the {@link Map} of {@link ExtensionElement} instances. These represent the extension elements defined in the BPMN 2.0 XML as
     * part of that particular activity.
     *
     * If the execution is currently being used for executing an {@link ExecutionListener}, the extension elements of the listener will be used. Use the
     * {@link #getFlowElementExtensionElements(DelegateExecution)} or {@link #getListenerExtensionElements(DelegateExecution)} instead to specifically get the extension elements of either the flow
     * element or the listener.
     */
    public static Map!(string, List!ExtensionElement) getExtensionElements(DelegateExecution execution) {
        if (isExecutingExecutionListener(execution)) {
            return getListenerExtensionElements(execution);
        } else {
            return getFlowElementExtensionElements(execution);
        }
    }

    public static Map!(string, List!ExtensionElement) getFlowElementExtensionElements(DelegateExecution execution) {
        return getFlowElement(execution).getExtensionElements();
    }

    public static Map!(string, List!ExtensionElement) getListenerExtensionElements(DelegateExecution execution) {
        return execution.getCurrentFlowableListener().getExtensionElements();
    }

    /**
     * Returns the list of field extensions, represented as instances of {@link FieldExtension}, for the current activity of the passed {@link DelegateExecution}.
     *
     * If the execution is currently being used for executing an {@link ExecutionListener}, the fields of the listener will be returned. Use {@link #getFlowElementFields(DelegateExecution)} or
     * {@link #getListenerFields(DelegateExecution)} if needing the flow element of listener fields specifically.
     */
    public static List!FieldExtension getFields(DelegateExecution execution) {
        if (isExecutingExecutionListener(execution)) {
            return getListenerFields(execution);
        } else {
            return getFlowElementFields(execution);
        }
    }

    public static List!FieldExtension getFlowElementFields(DelegateExecution execution) {
        FlowElement flowElement = getFlowElement(execution);
        if (cast(TaskWithFieldExtensions)flowElement !is null) {
            return (cast(TaskWithFieldExtensions) flowElement).getFieldExtensions();
        }
        return new ArrayList!FieldExtension();
    }

    public static List!FieldExtension getListenerFields(DelegateExecution execution) {
        return execution.getCurrentFlowableListener().getFieldExtensions();
    }

    /**
     * Returns the {@link FieldExtension} matching the provided 'fieldName' which is defined for the current activity of the provided {@link DelegateExecution}.
     *
     * Returns null if no such {@link FieldExtension} can be found.
     *
     * If the execution is currently being used for executing an {@link ExecutionListener}, the field of the listener will be returned. Use {@link #getFlowElementField(DelegateExecution, string)} or
     * {@link #getListenerField(DelegateExecution, string)} for specifically getting the field from either the flow element or the listener.
     */
    public static FieldExtension getField(DelegateExecution execution, string fieldName) {
        if (isExecutingExecutionListener(execution)) {
            return getListenerField(execution, fieldName);
        } else {
            return getFlowElementField(execution, fieldName);
        }
    }

    public static FieldExtension getFlowElementField(DelegateExecution execution, string fieldName) {
        List!FieldExtension fieldExtensions = getFlowElementFields(execution);
        if (fieldExtensions is null || fieldExtensions.size() == 0) {
            return null;
        }
        foreach (FieldExtension fieldExtension ; fieldExtensions) {
            if (fieldExtension.getFieldName() !is null && fieldExtension.getFieldName() == (fieldName)) {
                return fieldExtension;
            }
        }
        return null;
    }

    public static FieldExtension getListenerField(DelegateExecution execution, string fieldName) {
        List!FieldExtension fieldExtensions = getListenerFields(execution);
        if (fieldExtensions is null || fieldExtensions.size() == 0) {
            return null;
        }
        foreach (FieldExtension fieldExtension ; fieldExtensions) {
            if (fieldExtension.getFieldName() !is null && fieldExtension.getFieldName() == (fieldName)) {
                return fieldExtension;
            }
        }
        return null;
    }

    /**
     * Creates an {@link Expression} for the {@link FieldExtension}.
     */
    public static Expression createExpressionForField(FieldExtension fieldExtension) {
        if (fieldExtension.getExpression() !is null && fieldExtension.getExpression().length != 0) {
            ExpressionManager expressionManager = CommandContextUtil.getProcessEngineConfiguration().getExpressionManager();
            return expressionManager.createExpression(fieldExtension.getExpression());
        } else {
            return new FixedValue(new String(fieldExtension.getStringValue()));
        }
    }

    /**
     * Returns the {@link Expression} for the field defined for the current activity of the provided {@link DelegateExecution}.
     *
     * Returns null if no such field was found in the process definition xml.
     *
     * If the execution is currently being used for executing an {@link ExecutionListener}, it will return the field expression for the listener. Use
     * {@link #getFlowElementFieldExpression(DelegateExecution, string)} or {@link #getListenerFieldExpression(DelegateExecution, string)} for specifically getting the flow element or listener field
     * expression.
     */
    public static Expression getFieldExpression(DelegateExecution execution, string fieldName) {
        if (isExecutingExecutionListener(execution)) {
            return getListenerFieldExpression(execution, fieldName);
        } else {
            return getFlowElementFieldExpression(execution, fieldName);
        }
    }

    /**
     * Similar to {@link #getFieldExpression(DelegateExecution, string)}, but for use within a {@link TaskListener}.
     */
    public static Expression getFieldExpression(DelegateTask task, string fieldName) {
        string eventHandlerId = task.getEventHandlerId();
        if (eventHandlerId !is null && task.getProcessDefinitionId() !is null) {
            flow.bpmn.model.Process.Process process = ProcessDefinitionUtil.getProcess(task.getProcessDefinitionId());
            UserTask userTask = cast(UserTask) process.getFlowElementMap().get(task.getTaskDefinitionKey());

            FlowableListener flowableListener = null;
            foreach (FlowableListener f ; userTask.getTaskListeners()) {
                if (f.getId() !is null && f.getId() == (eventHandlerId)) {
                    flowableListener = f;
                }
            }

            if (flowableListener !is null) {
                List!FieldExtension fieldExtensions = flowableListener.getFieldExtensions();
                if (fieldExtensions !is null && fieldExtensions.size() > 0) {
                    foreach (FieldExtension fieldExtension ; fieldExtensions) {
                        if (fieldName == (fieldExtension.getFieldName())) {
                            return createExpressionForField(fieldExtension);
                        }
                    }
                }
            }
        }
        return null;
    }

    public static Expression getFlowElementFieldExpression(DelegateExecution execution, string fieldName) {
        FieldExtension fieldExtension = getFlowElementField(execution, fieldName);
        if (fieldExtension !is null) {
            return createExpressionForField(fieldExtension);
        }
        return null;
    }

    public static Expression getListenerFieldExpression(DelegateExecution execution, string fieldName) {
        FieldExtension fieldExtension = getListenerField(execution, fieldName);
        if (fieldExtension !is null) {
            return createExpressionForField(fieldExtension);
        }
        return null;
    }

}
