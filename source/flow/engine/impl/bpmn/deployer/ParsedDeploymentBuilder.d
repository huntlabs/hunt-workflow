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
module flow.engine.impl.bpmn.deployer.ParsedDeploymentBuilder;


import flow.engine.impl.bpmn.deployer.ResourceNameUtil;
import hunt.stream.ByteArrayInputStream;
import hunt.collection.LinkedHashMap;
import hunt.collection.List;
import hunt.collection.Map;
import hunt.collection.ArrayList;
import flow.common.api.repository.EngineDeployment;
import flow.common.api.repository.EngineResource;
import flow.engine.impl.bpmn.parser.BpmnParse;
import flow.engine.impl.bpmn.parser.BpmnParser;
import flow.engine.impl.cmd.DeploymentSettings;
import flow.engine.impl.persistence.entity.DeploymentEntity;
import flow.engine.impl.persistence.entity.ProcessDefinitionEntity;
import flow.engine.impl.bpmn.deployer.ParsedDeployment;
import hunt.Boolean;

import hunt.logging;
import std.algorithm.searching;

class ParsedDeploymentBuilder {

    protected EngineDeployment deployment;
    protected BpmnParser bpmnParser;
    protected Map!(string, Object) deploymentSettings;

    this(EngineDeployment deployment,
            BpmnParser bpmnParser, Map!(string, Object) deploymentSettings) {
        this.deployment = deployment;
        this.bpmnParser = bpmnParser;
        this.deploymentSettings = deploymentSettings;
    }

    public ParsedDeployment build() {
        List!ProcessDefinitionEntity processDefinitions = new ArrayList!ProcessDefinitionEntity();
        Map!(ProcessDefinitionEntity, BpmnParse) processDefinitionsToBpmnParseMap = new LinkedHashMap!(ProcessDefinitionEntity, BpmnParse)();
        Map!(ProcessDefinitionEntity, EngineResource) processDefinitionsToResourceMap = new LinkedHashMap!(ProcessDefinitionEntity, EngineResource)();

        DeploymentEntity deploymentEntity = cast(DeploymentEntity) deployment;
        foreach (EngineResource resource ; deploymentEntity.getResources().values()) {
            if (isBpmnResource(resource.getName())) {
                logInfo("Processing BPMN resource {%s}", resource.getName());
                BpmnParse parse = createBpmnParseFromResource(resource);
                foreach (ProcessDefinitionEntity processDefinition ; parse.getProcessDefinitions()) {
                    processDefinitions.add(processDefinition);
                    processDefinitionsToBpmnParseMap.put(processDefinition, parse);
                    processDefinitionsToResourceMap.put(processDefinition, resource);
                }
            }
        }

        return new ParsedDeployment(deploymentEntity, processDefinitions,
                processDefinitionsToBpmnParseMap, processDefinitionsToResourceMap);
    }

    protected BpmnParse createBpmnParseFromResource(EngineResource resource) {
        string resourceName = resource.getName();
        ByteArrayInputStream inputStream = new ByteArrayInputStream(resource.getBytes());

        BpmnParse bpmnParse = bpmnParser.createParse()
                .sourceInputStream(inputStream)
                .setSourceSystemId(resourceName)
                .deployment(deployment)
                .name(resourceName);

        if (deploymentSettings !is null) {

            // Schema validation if needed
            if (deploymentSettings.containsKey(DeploymentSettings.IS_BPMN20_XSD_VALIDATION_ENABLED)) {
                bpmnParse.setValidateSchema((cast(Boolean) deploymentSettings.get(DeploymentSettings.IS_BPMN20_XSD_VALIDATION_ENABLED)).booleanValue());
            }

            // Process validation if needed
            if (deploymentSettings.containsKey(DeploymentSettings.IS_PROCESS_VALIDATION_ENABLED)) {
                bpmnParse.setValidateProcess((cast(Boolean) deploymentSettings.get(DeploymentSettings.IS_PROCESS_VALIDATION_ENABLED)).booleanValue());
            }

        } else {
            // On redeploy, we assume it is validated at the first deploy
            bpmnParse.setValidateSchema(false);
            bpmnParse.setValidateProcess(false);
        }

        try {
            bpmnParse.execute();
        } catch (Exception e) {
            logError("Could not parse resource {%s}", resource.getName());
            throw e;
        }
        return bpmnParse;
    }

    protected bool isBpmnResource(string resourceName) {
        foreach (string suffix ; ResourceNameUtil.BPMN_RESOURCE_SUFFIXES) {
            if (endsWith(resourceName,(suffix)) == 0) {
                return true;
            }
        }

        return false;
    }

}
