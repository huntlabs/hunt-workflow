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
module flow.engine.impl.app.AppDeployer;


import hunt.collection.Map;

import flow.common.api.repository.EngineDeployment;
import flow.common.api.repository.EngineResource;
import flow.common.EngineDeployer;
import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
import flow.engine.impl.persistence.deploy.DeploymentManager;
import flow.engine.impl.persistence.entity.DeploymentEntity;
import flow.engine.impl.util.CommandContextUtil;
import hunt.logging;
import std.algorithm;
/**
 * @author Tijs Rademakers
 */
class AppDeployer : EngineDeployer {

    public void deploy(EngineDeployment deployment, Map!(string, Object) deploymentSettings) {
        logInfo("Processing app deployment {%s}", deployment.getName());

        ProcessEngineConfigurationImpl processEngineConfiguration = CommandContextUtil.getProcessEngineConfiguration();
        DeploymentManager deploymentManager = processEngineConfiguration.getDeploymentManager();

        Object appResourceObject = null;
        DeploymentEntity deploymentEntity = cast(DeploymentEntity) deployment;
        Map!(string, EngineResource) resources = deploymentEntity.getResources();
        foreach (string resourceName ; resources.byKey()) {
            if (endsWith(resourceName,".app")) {
                logInfo("Processing app resource {%s}", resourceName);

                EngineResource resourceEntity = resources.get(resourceName);
                byte[] resourceBytes = resourceEntity.getBytes();
                appResourceObject = processEngineConfiguration.getAppResourceConverter().convertAppResourceToModel(resourceBytes);
            }
        }

        if (appResourceObject !is null) {
            deploymentManager.getAppResourceCache().add(deployment.getId(), appResourceObject);
        }
    }
}
