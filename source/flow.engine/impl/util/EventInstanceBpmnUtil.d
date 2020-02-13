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


import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.function.Function;
import java.util.stream.Collectors;

import org.apache.commons.lang3.StringUtils;
import org.flowable.bpmn.constants.BpmnXMLConstants;
import org.flowable.bpmn.model.BaseElement;
import org.flowable.bpmn.model.ExtensionElement;
import org.flowable.bpmn.model.IOParameter;
import org.flowable.bpmn.model.SendEventServiceTask;
import flow.common.api.delegate.Expression;
import flow.common.el.ExpressionManager;
import org.flowable.eventregistry.api.runtime.EventInstance;
import org.flowable.eventregistry.api.runtime.EventPayloadInstance;
import org.flowable.eventregistry.impl.runtime.EventPayloadInstanceImpl;
import org.flowable.eventregistry.model.EventModel;
import org.flowable.eventregistry.model.EventPayload;
import org.flowable.variable.api.delegate.VariableScope;

class EventInstanceBpmnUtil {

    /**
     * Processes the 'out parameters' of an {@link EventInstance} and stores the corresponding variables on the {@link VariableScope}.
     *
     * Typically used when mapping incoming event payload into a runtime instance (the {@link VariableScope)}.
     */
    public static void handleEventInstanceOutParameters(VariableScope variableScope, BaseElement baseElement, EventInstance eventInstance) {
        Map<string, EventPayloadInstance> payloadInstances = eventInstance.getPayloadInstances()
                .stream()
                .collect(Collectors.toMap(EventPayloadInstance::getDefinitionName, Function.identity()));
        
        if (baseElement instanceof SendEventServiceTask) {
            SendEventServiceTask eventServiceTask = (SendEventServiceTask) baseElement;
            if (!eventServiceTask.getEventOutParameters().isEmpty()) {
                for (IOParameter parameter : eventServiceTask.getEventOutParameters()) {
                    setEventParameterVariable(parameter.getSource(), parameter.getTarget(), parameter.isTransient(), payloadInstances, variableScope);
                }
            }
            
        } else {
            List<ExtensionElement> outParameters = baseElement.getExtensionElements()
                    .getOrDefault(BpmnXMLConstants.ELEMENT_EVENT_OUT_PARAMETER, Collections.emptyList());
            if (!outParameters.isEmpty()) {
                for (ExtensionElement outParameter : outParameters) {
                    string payloadSourceName = outParameter.getAttributeValue(null, BpmnXMLConstants.ATTRIBUTE_IOPARAMETER_SOURCE);
                    string variableName = outParameter.getAttributeValue(null, BpmnXMLConstants.ATTRIBUTE_IOPARAMETER_TARGET);
                    bool isTransient = bool.valueOf(outParameter.getAttributeValue(null, "transient"));
                    setEventParameterVariable(payloadSourceName, variableName, isTransient, payloadInstances, variableScope);
                }
            }
        }
    }

    /**
     * Reads the 'in parameters' and converts them to {@link EventPayloadInstance} instances.
     *
     * Typically used when needing to create {@link EventInstance}'s and populate the payload.
     */
    public static Collection<EventPayloadInstance> createEventPayloadInstances(VariableScope variableScope, ExpressionManager expressionManager,
            BaseElement baseElement, EventModel eventDefinition) {

        List<EventPayloadInstance> eventPayloadInstances = new ArrayList<>();
        if (baseElement instanceof SendEventServiceTask) {
            SendEventServiceTask eventServiceTask = (SendEventServiceTask) baseElement;
            if (!eventServiceTask.getEventInParameters().isEmpty()) {
                for (IOParameter parameter : eventServiceTask.getEventInParameters()) {
                    string sourceValue = null;
                    if (StringUtils.isNotEmpty(parameter.getSourceExpression())) {
                        sourceValue = parameter.getSourceExpression();
                    } else {
                        sourceValue = parameter.getSource();
                    }
                    addEventPayloadInstance(eventPayloadInstances, sourceValue, parameter.getTarget(), 
                                    variableScope, expressionManager, eventDefinition);
                }
            }
            
        } else {
            List<ExtensionElement> inParameters = baseElement.getExtensionElements()
                .getOrDefault(BpmnXMLConstants.ELEMENT_EVENT_IN_PARAMETER, Collections.emptyList());
    
            if (!inParameters.isEmpty()) {
    
                for (ExtensionElement inParameter : inParameters) {
    
                    string sourceExpression = inParameter.getAttributeValue(null, BpmnXMLConstants.ATTRIBUTE_IOPARAMETER_SOURCE_EXPRESSION);
                    string source = inParameter.getAttributeValue(null, BpmnXMLConstants.ATTRIBUTE_IOPARAMETER_SOURCE);
                    string target = inParameter.getAttributeValue(null, BpmnXMLConstants.ATTRIBUTE_IOPARAMETER_TARGET);
                    
                    string sourceValue = null;
                    if (StringUtils.isNotEmpty(sourceExpression)) {
                        sourceValue = sourceExpression;
                    } else {
                        sourceValue = source;
                    }
    
                    addEventPayloadInstance(eventPayloadInstances, sourceValue, target, variableScope, expressionManager, eventDefinition);
                }
            }
        }

        return eventPayloadInstances;
    }
    
    protected static void setEventParameterVariable(string source, string target, bool isTransient,
                    Map<string, EventPayloadInstance> payloadInstances, VariableScope variableScope) {
        
        EventPayloadInstance payloadInstance = payloadInstances.get(source);
        if (StringUtils.isNotEmpty(target)) {
            Object value = payloadInstance != null ? payloadInstance.getValue() : null;
            if (bool.TRUE.equals(isTransient)) {
                variableScope.setTransientVariable(target, value);
            } else {
                variableScope.setVariable(target, value);
            }
        }
    }
    
    protected static void addEventPayloadInstance(List<EventPayloadInstance> eventPayloadInstances, string source, string target,
                    VariableScope variableScope, ExpressionManager expressionManager, EventModel eventDefinition) {
        
        Optional<EventPayload> matchingEventDefinition = eventDefinition.getPayload()
            .stream()
            .filter(e -> e.getName().equals(target))
            .findFirst();
        if (matchingEventDefinition.isPresent()) {
            EventPayload eventPayloadDefinition = matchingEventDefinition.get();

            Expression sourceExpression = expressionManager.createExpression(source);
            Object value = sourceExpression.getValue(variableScope);

            eventPayloadInstances.add(new EventPayloadInstanceImpl(eventPayloadDefinition, value));
        }
    }

}
