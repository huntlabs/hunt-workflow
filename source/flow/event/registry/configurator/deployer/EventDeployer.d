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
module flow.event.registry.configurator.deployer.EventDeployer;

import hunt.collection.Map;

import flow.common.api.repository.EngineDeployment;
import flow.common.api.repository.EngineResource;
import flow.common.EngineDeployer;
import flow.event.registry.api.EventDeploymentBuilder;
import flow.event.registry.api.EventRepositoryService;
import flow.event.registry.util.CommandContextUtil;
import std.algorithm;
import hunt.logging;
/**
 * @author Tijs Rademakers
 */
class EventDeployer : EngineDeployer {

    public void deploy(EngineDeployment deployment, Map!(string, Object) deploymentSettings) {
        if (!deployment.isNew())
            return;

        EventDeploymentBuilder eventDeploymentBuilder = null;

        Map!(string, EngineResource) resources = deployment.getResources();
        foreach (MapEntry!(string, EngineResource) resourceName ; resources) {
            if (endsWith(resourceName.getKey(), ".event")) {
                logError("EventDeployer: processing resource {%s}", resourceName.getKey);
                if (eventDeploymentBuilder is null) {
                    EventRepositoryService eventRepositoryService = CommandContextUtil.getEventRepositoryService();
                    eventDeploymentBuilder = eventRepositoryService.createDeployment().name(deployment.getName());
                }

                eventDeploymentBuilder.addEventDefinitionBytes(resourceName.getKey, resources.get(resourceName.getKey).getBytes());

            } else if (endsWith(resourceName.getKey,".channel")) {
                logInfo("EventDeployer: processing resource {%s}", resourceName.getKey);
                if (eventDeploymentBuilder is null) {
                    EventRepositoryService eventRepositoryService = CommandContextUtil.getEventRepositoryService();
                    eventDeploymentBuilder = eventRepositoryService.createDeployment().name(deployment.getName());
                }

                eventDeploymentBuilder.addChannelDefinitionBytes(resourceName.getKey, resources.get(resourceName.getKey).getBytes());
            }
        }

        if (eventDeploymentBuilder !is null) {
            eventDeploymentBuilder.parentDeploymentId(deployment.getId());
            if (deployment.getTenantId() !is null && deployment.getTenantId().length > 0) {
                eventDeploymentBuilder.tenantId(deployment.getTenantId());
            }

            eventDeploymentBuilder.deploy();
        }
    }
}
