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



import hunt.collection.HashMap;
import hunt.collection.HashSet;
import hunt.collection.LinkedHashSet;
import hunt.collection.List;
import java.util.Locale;
import hunt.collection.Map;
import java.util.ResourceBundle;

import flow.engine.impl.persistence.deploy.ProcessDefinitionInfoCacheObject;
import flow.engine.impl.util.CommandContextUtil;

import com.fasterxml.jackson.databind.node.ObjectNode;

class BpmnOverrideContext {

    protected static ThreadLocal<Map!(string, ObjectNode)> bpmnOverrideContextThreadLocal = new ThreadLocal<>();

    protected static ResourceBundle.Control resourceBundleControl = new ResourceBundleControl();

    public static ObjectNode getBpmnOverrideElementProperties(string id, string processDefinitionId) {
        ObjectNode definitionInfoNode = getProcessDefinitionInfoNode(processDefinitionId);
        ObjectNode elementProperties = null;
        if (definitionInfoNode !is null) {
            elementProperties = CommandContextUtil.getProcessEngineConfiguration().getDynamicBpmnService().getBpmnElementProperties(id, definitionInfoNode);
        }
        return elementProperties;
    }

    public static ObjectNode getLocalizationElementProperties(string language, string id, string processDefinitionId, bool useFallback) {
        ObjectNode definitionInfoNode = getProcessDefinitionInfoNode(processDefinitionId);
        ObjectNode localizationProperties = null;
        if (definitionInfoNode !is null) {
            if (!useFallback) {
                localizationProperties = CommandContextUtil.getProcessEngineConfiguration().getDynamicBpmnService().getLocalizationElementProperties(
                        language, id, definitionInfoNode);

            } else {
                HashSet!Locale candidateLocales = new LinkedHashSet<>();
                candidateLocales.addAll(resourceBundleControl.getCandidateLocales(id, Locale.forLanguageTag(language)));
                for (Locale locale : candidateLocales) {
                    localizationProperties = CommandContextUtil.getProcessEngineConfiguration().getDynamicBpmnService().getLocalizationElementProperties(
                            locale.toLanguageTag(), id, definitionInfoNode);

                    if (localizationProperties !is null) {
                        break;
                    }
                }
            }
        }
        return localizationProperties;
    }

    public static void removeBpmnOverrideContext() {
        bpmnOverrideContextThreadLocal.remove();
    }

    public static ObjectNode getProcessDefinitionInfoNode(string processDefinitionId) {
        Map!(string, ObjectNode) bpmnOverrideMap = getBpmnOverrideContext();
        if (!bpmnOverrideMap.containsKey(processDefinitionId)) {
            ProcessDefinitionInfoCacheObject cacheObject = CommandContextUtil.getProcessEngineConfiguration().getDeploymentManager()
                    .getProcessDefinitionInfoCache()
                    .get(processDefinitionId);

            addBpmnOverrideElement(processDefinitionId, cacheObject.getInfoNode());
        }

        return getBpmnOverrideContext().get(processDefinitionId);
    }

    protected static Map!(string, ObjectNode) getBpmnOverrideContext() {
        Map!(string, ObjectNode) bpmnOverrideMap = bpmnOverrideContextThreadLocal.get();
        if (bpmnOverrideMap is null) {
            bpmnOverrideMap = new HashMap<>();
        }
        return bpmnOverrideMap;
    }

    protected static void addBpmnOverrideElement(string id, ObjectNode infoNode) {
        Map!(string, ObjectNode) bpmnOverrideMap = bpmnOverrideContextThreadLocal.get();
        if (bpmnOverrideMap is null) {
            bpmnOverrideMap = new HashMap<>();
            bpmnOverrideContextThreadLocal.set(bpmnOverrideMap);
        }
        bpmnOverrideMap.put(id, infoNode);
    }

    public static class ResourceBundleControl : ResourceBundle.Control {
        override
        public List!Locale getCandidateLocales(string baseName, Locale locale) {
            return super.getCandidateLocales(baseName, locale);
        }
    }
}
