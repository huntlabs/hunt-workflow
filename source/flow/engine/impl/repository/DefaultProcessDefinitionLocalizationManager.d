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

module flow.engine.impl.repository.DefaultProcessDefinitionLocalizationManager;

import flow.engine.DynamicBpmnConstants;
import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
//import flow.engine.impl.context.BpmnOverrideContext;
import flow.engine.impl.persistence.entity.ProcessDefinitionEntity;
import flow.engine.repository.InternalProcessDefinitionLocalizationManager;
import flow.engine.repository.ProcessDefinition;
import hunt.Exceptions;

/**
 * @author David Lamas
 */
class DefaultProcessDefinitionLocalizationManager : InternalProcessDefinitionLocalizationManager {
    protected ProcessEngineConfigurationImpl processEngineConfiguration;

    this(ProcessEngineConfigurationImpl processEngineConfiguration) {
        this.processEngineConfiguration = processEngineConfiguration;
    }

    public void localize(ProcessDefinition processDefinition, string locale, bool withLocalizationFallback) {
        ProcessDefinitionEntity processDefinitionEntity = cast(ProcessDefinitionEntity) processDefinition;
        processDefinitionEntity.setLocalizedName(null);
        processDefinitionEntity.setLocalizedDescription(null);

        if (locale !is null) {
            implementationMissing(false);
            //ObjectNode languageNode = BpmnOverrideContext.getLocalizationElementProperties(locale, processDefinitionEntity.getKey(), processDefinition.getId(), withLocalizationFallback);
            //if (languageNode !is null) {
            //    JsonNode languageNameNode = languageNode.get(DynamicBpmnConstants.LOCALIZATION_NAME);
            //    if (languageNameNode !is null && !languageNameNode.isNull()) {
            //        processDefinitionEntity.setLocalizedName(languageNameNode.asText());
            //    }
            //
            //    JsonNode languageDescriptionNode = languageNode.get(DynamicBpmnConstants.LOCALIZATION_DESCRIPTION);
            //    if (languageDescriptionNode !is null && !languageDescriptionNode.isNull()) {
            //        processDefinitionEntity.setLocalizedDescription(languageDescriptionNode.asText());
            //    }
            //}
        }
    }
}
