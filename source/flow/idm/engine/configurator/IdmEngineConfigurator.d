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

module flow.idm.engine.configurator.IdmEngineConfigurator;

import hunt.collection.List;

import flow.common.AbstractEngineConfiguration;
import flow.common.AbstractEngineConfigurator;
import flow.common.EngineDeployer;
import flow.common.interceptor.EngineConfigurationConstants;
import flow.common.persistence.entity.Entity;
import flow.idm.engine.IdmEngineConfiguration;
import flow.idm.engine.impl.cfg.StandaloneIdmEngineConfiguration;
import flow.idm.engine.impl.db.EntityDependencyOrder;

/**
 * @author Tijs Rademakers
 * @author Joram Barrez
 */
class IdmEngineConfigurator : AbstractEngineConfigurator {

    protected IdmEngineConfiguration idmEngineConfiguration;

    public int getPriority() {
        return EngineConfigurationConstants.PRIORITY_ENGINE_IDM;
    }

    override
    protected List!EngineDeployer getCustomDeployers() {
        return null;
    }

    override
    protected string getMybatisCfgPath() {
        return IdmEngineConfiguration.DEFAULT_MYBATIS_MAPPING_FILE;
    }

    public void configure(AbstractEngineConfiguration engineConfiguration) {
        if (idmEngineConfiguration is null) {
            idmEngineConfiguration = new StandaloneIdmEngineConfiguration();
        }

        initialiseCommonProperties(engineConfiguration, idmEngineConfiguration);

        idmEngineConfiguration.buildIdmEngine();

        initServiceConfigurations(engineConfiguration, idmEngineConfiguration);
    }

    //protected List<Class<? extends Entity>> getEntityInsertionOrder() {
    //    return EntityDependencyOrder.INSERT_ORDER;
    //}
    //
    //protected List<Class<? extends Entity>> getEntityDeletionOrder() {
    //    return EntityDependencyOrder.DELETE_ORDER;
    //}

    public IdmEngineConfiguration getIdmEngineConfiguration() {
        return idmEngineConfiguration;
    }

    public IdmEngineConfigurator setIdmEngineConfiguration(IdmEngineConfiguration idmEngineConfiguration) {
        this.idmEngineConfiguration = idmEngineConfiguration;
        return this;
    }

}
