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

module flow.engine.impl.cfg.DefaultTaskLocalizationManager;

import flow.engine.DynamicBpmnConstants;
//import flow.engine.impl.context.BpmnOverrideContext;
import flow.engine.impl.persistence.entity.ExecutionEntityManager;
import flow.task.api.Task;
import flow.task.api.history.HistoricTaskInstance;
import flow.task.service.InternalTaskLocalizationManager;
import flow.task.service.impl.persistence.entity.HistoricTaskInstanceEntity;
import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
//import com.fasterxml.jackson.databind.JsonNode;
//import com.fasterxml.jackson.databind.node.ObjectNode;
import hunt.Exceptions;
/**
 * @author Tijs Rademakers
 */
class DefaultTaskLocalizationManager : InternalTaskLocalizationManager {

    protected ProcessEngineConfigurationImpl processEngineConfiguration;

    this(ProcessEngineConfigurationImpl processEngineConfiguration) {
        this.processEngineConfiguration = processEngineConfiguration;
    }


    public void localize(Task task, string locale, bool withLocalizationFallback) {
        task.setLocalizedName(null);
        task.setLocalizedDescription(null);

        if (locale !is null && locale.length != 0) {
            implementationMissing(false);
            //string processDefinitionId = task.getProcessDefinitionId();
            //if (processDefinitionId !is null && processDefinitionId.length != 0) {
            //    ObjectNode languageNode = BpmnOverrideContext.getLocalizationElementProperties(locale, task.getTaskDefinitionKey(), processDefinitionId, withLocalizationFallback);
            //    if (languageNode !is null) {
            //        JsonNode languageNameNode = languageNode.get(DynamicBpmnConstants.LOCALIZATION_NAME);
            //        if (languageNameNode !is null && !languageNameNode.isNull()) {
            //            task.setLocalizedName(languageNameNode.asText());
            //        }
            //
            //        JsonNode languageDescriptionNode = languageNode.get(DynamicBpmnConstants.LOCALIZATION_DESCRIPTION);
            //        if (languageDescriptionNode !is null && !languageDescriptionNode.isNull()) {
            //            task.setLocalizedDescription(languageDescriptionNode.asText());
            //        }
            //    }
            //}
        }
    }


    public void localize(HistoricTaskInstance task, string locale, bool withLocalizationFallback) {
        HistoricTaskInstanceEntity taskEntity = cast(HistoricTaskInstanceEntity) task;
        taskEntity.setLocalizedName(null);
        taskEntity.setLocalizedDescription(null);

        if (locale !is null) {
            string processDefinitionId = task.getProcessDefinitionId();
            if (processDefinitionId !is null && processDefinitionId.length != 0) {
                implementationMissing(false);
                //ObjectNode languageNode = BpmnOverrideContext.getLocalizationElementProperties(locale, task.getTaskDefinitionKey(), processDefinitionId, withLocalizationFallback);
                //if (languageNode !is null) {
                //    JsonNode languageNameNode = languageNode.get(DynamicBpmnConstants.LOCALIZATION_NAME);
                //    if (languageNameNode !is null && !languageNameNode.isNull()) {
                //        taskEntity.setLocalizedName(languageNameNode.asText());
                //    }
                //
                //    JsonNode languageDescriptionNode = languageNode.get(DynamicBpmnConstants.LOCALIZATION_DESCRIPTION);
                //    if (languageDescriptionNode !is null && !languageDescriptionNode.isNull()) {
                //        taskEntity.setLocalizedDescription(languageDescriptionNode.asText());
                //    }
                //}
            }
        }
    }

    protected ExecutionEntityManager getExecutionEntityManager() {
        return processEngineConfiguration.getExecutionEntityManager();
    }
}
