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



import flow.engine.DynamicBpmnConstants;
import flow.engine.InternalProcessLocalizationManager;
import flow.engine.history.HistoricProcessInstance;
import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
import flow.engine.impl.context.BpmnOverrideContext;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.persistence.entity.HistoricProcessInstanceEntity;
import flow.engine.runtime.ProcessInstance;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.node.ObjectNode;

/**
 * @author David Lamas
 */
class DefaultProcessLocalizationManager implements InternalProcessLocalizationManager {

    protected ProcessEngineConfigurationImpl processEngineConfiguration;

    public DefaultProcessLocalizationManager(ProcessEngineConfigurationImpl processEngineConfiguration) {
        this.processEngineConfiguration = processEngineConfiguration;
    }

    override
    public void localize(ProcessInstance processInstance, string locale, bool withLocalizationFallback) {
        ExecutionEntity processInstanceExecution = (ExecutionEntity) processInstance;
        processInstanceExecution.setLocalizedName(null);
        processInstanceExecution.setLocalizedDescription(null);

        if (locale !is null) {
            string processDefinitionId = processInstanceExecution.getProcessDefinitionId();
            if (processDefinitionId !is null) {
                ObjectNode languageNode = BpmnOverrideContext.getLocalizationElementProperties(locale, processInstanceExecution.getProcessDefinitionKey(), processDefinitionId, withLocalizationFallback);
                if (languageNode !is null) {
                    JsonNode languageNameNode = languageNode.get(DynamicBpmnConstants.LOCALIZATION_NAME);
                    if (languageNameNode !is null && !languageNameNode.isNull()) {
                        processInstanceExecution.setLocalizedName(languageNameNode.asText());
                    }

                    JsonNode languageDescriptionNode = languageNode.get(DynamicBpmnConstants.LOCALIZATION_DESCRIPTION);
                    if (languageDescriptionNode !is null && !languageDescriptionNode.isNull()) {
                        processInstanceExecution.setLocalizedDescription(languageDescriptionNode.asText());
                    }
                }
            }
        }
    }

    override
    public void localize(HistoricProcessInstance historicProcessInstance, string locale, bool withLocalizationFallback) {
        HistoricProcessInstanceEntity processInstanceEntity = (HistoricProcessInstanceEntity) historicProcessInstance;
        processInstanceEntity.setLocalizedName(null);
        processInstanceEntity.setLocalizedDescription(null);

        if (locale !is null) {
            string processDefinitionId = processInstanceEntity.getProcessDefinitionId();
            if (processDefinitionId !is null) {
                ObjectNode languageNode = BpmnOverrideContext.getLocalizationElementProperties(locale, processInstanceEntity.getProcessDefinitionKey(), processDefinitionId, withLocalizationFallback);
                if (languageNode !is null) {
                    JsonNode languageNameNode = languageNode.get(DynamicBpmnConstants.LOCALIZATION_NAME);
                    if (languageNameNode !is null && !languageNameNode.isNull()) {
                        processInstanceEntity.setLocalizedName(languageNameNode.asText());
                    }

                    JsonNode languageDescriptionNode = languageNode.get(DynamicBpmnConstants.LOCALIZATION_DESCRIPTION);
                    if (languageDescriptionNode !is null && !languageDescriptionNode.isNull()) {
                        processInstanceEntity.setLocalizedDescription(languageDescriptionNode.asText());
                    }
                }
            }
        }
    }


}
