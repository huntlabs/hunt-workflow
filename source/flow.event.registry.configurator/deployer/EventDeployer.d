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


import hunt.collection.Map;

import flow.common.api.repository.EngineDeployment;
import flow.common.api.repository.EngineResource;
import flow.common.EngineDeployer;
import flow.event.registry.api.EventDeploymentBuilder;
import flow.event.registry.api.EventRepositoryService;
import flow.event.registry.util.CommandContextUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * @author Tijs Rademakers
 */
class EventDeployer implements EngineDeployer {

    private static final Logger LOGGER = LoggerFactory.getLogger(EventDeployer.class);

    @Override
    public void deploy(EngineDeployment deployment, Map!(string, Object) deploymentSettings) {
        if (!deployment.isNew())
            return;

        LOGGER.debug("EventDeployer: processing deployment {}", deployment.getName());

        EventDeploymentBuilder eventDeploymentBuilder = null;

        Map<String, EngineResource> resources = deployment.getResources();
        for (String resourceName : resources.keySet()) {
            if (resourceName.endsWith(".event")) {
                LOGGER.info("EventDeployer: processing resource {}", resourceName);
                if (eventDeploymentBuilder is null) {
                    EventRepositoryService eventRepositoryService = CommandContextUtil.getEventRepositoryService();
                    eventDeploymentBuilder = eventRepositoryService.createDeployment().name(deployment.getName());
                }

                eventDeploymentBuilder.addEventDefinitionBytes(resourceName, resources.get(resourceName).getBytes());

            } else if (resourceName.endsWith(".channel")) {
                LOGGER.info("EventDeployer: processing resource {}", resourceName);
                if (eventDeploymentBuilder is null) {
                    EventRepositoryService eventRepositoryService = CommandContextUtil.getEventRepositoryService();
                    eventDeploymentBuilder = eventRepositoryService.createDeployment().name(deployment.getName());
                }

                eventDeploymentBuilder.addChannelDefinitionBytes(resourceName, resources.get(resourceName).getBytes());
            }
        }

        if (eventDeploymentBuilder !is null) {
            eventDeploymentBuilder.parentDeploymentId(deployment.getId());
            if (deployment.getTenantId() !is null && deployment.getTenantId().length() > 0) {
                eventDeploymentBuilder.tenantId(deployment.getTenantId());
            }

            eventDeploymentBuilder.deploy();
        }
    }
}
