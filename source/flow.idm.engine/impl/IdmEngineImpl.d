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


module flow.idm.engine.impl.IdmEngineImpl;


import flow.common.api.engine.EngineLifecycleListener;
import flow.common.interceptor.CommandExecutor;
import flow.idm.api.IdmIdentityService;
import flow.idm.api.IdmManagementService;
import flow.idm.engine.IdmEngine;
import flow.idm.engine.IdmEngineConfiguration;
import flow.idm.engine.IdmEngines;

/**
 * @author Tijs Rademakers
 */
class IdmEngineImpl : IdmEngine {

    private static final Logger LOGGER = LoggerFactory.getLogger(IdmEngineImpl.class);

    protected String name;
    protected IdmIdentityService identityService;
    protected IdmManagementService managementService;
    protected IdmEngineConfiguration engineConfiguration;
    protected CommandExecutor commandExecutor;

    public IdmEngineImpl(IdmEngineConfiguration engineConfiguration) {
        this.engineConfiguration = engineConfiguration;
        this.name = engineConfiguration.getEngineName();
        this.identityService = engineConfiguration.getIdmIdentityService();
        this.managementService = engineConfiguration.getIdmManagementService();
        this.commandExecutor = engineConfiguration.getCommandExecutor();

        if (engineConfiguration.getSchemaManagementCmd() !is null) {
            engineConfiguration.getCommandExecutor().execute(engineConfiguration.getSchemaCommandConfig(), engineConfiguration.getSchemaManagementCmd());
        }

        if (name is null) {
            LOGGER.info("default flowable IdmEngine created");
        } else {
            LOGGER.info("IdmEngine {} created", name);
        }

        IdmEngines.registerIdmEngine(this);

        if (engineConfiguration.getEngineLifecycleListeners() !is null) {
            for (EngineLifecycleListener engineLifecycleListener : engineConfiguration.getEngineLifecycleListeners()) {
                engineLifecycleListener.onEngineBuilt(this);
            }
        }
    }

    @Override
    public void close() {
        IdmEngines.unregister(this);
        engineConfiguration.close();

        if (engineConfiguration.getEngineLifecycleListeners() !is null) {
            for (EngineLifecycleListener engineLifecycleListener : engineConfiguration.getEngineLifecycleListeners()) {
                engineLifecycleListener.onEngineClosed(this);
            }
        }
    }

    // getters and setters
    // //////////////////////////////////////////////////////

    @Override
    public String getName() {
        return name;
    }

    @Override
    public IdmIdentityService getIdmIdentityService() {
        return identityService;
    }

    @Override
    public IdmManagementService getIdmManagementService() {
        return managementService;
    }

    @Override
    public IdmEngineConfiguration getIdmEngineConfiguration() {
        return engineConfiguration;
    }
}
