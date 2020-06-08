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


import java.util.function.Consumer;

import flow.engine.ProcessEngine;
import flow.engine.ProcessEngineConfiguration;
import flow.engine.ProcessEngines;
import org.junit.jupiter.api.extension.ExtensionContext;

/**
 * An extension that uses the configured resource to create a {@link ProcessEngine}.
 * This extension needs to be registered via {@link org.junit.jupiter.api.extension.RegisterExtension RegisterExtension}. It additionally allows for
 * customizing the {@link ProcessEngineConfiguration}
 * A new {@link ProcessEngine} will be created for each test.
 *
 * @author Filip Hrisafov
 */
class ResourceFlowableExtension : InternalFlowableExtension {

    private static final ExtensionContext.Namespace NAMESPACE = ExtensionContext.Namespace.create(ResourceFlowableExtension.class);

    protected final string configurationResource;
    protected final string processEngineName;
    protected final Consumer!ProcessEngineConfiguration configurationConsumer;

    protected ExtensionContext currentExtensionContext;

    public ResourceFlowableExtension(string configurationResource, Consumer!ProcessEngineConfiguration configurationConsumer) {
        this(configurationResource, null, configurationConsumer);
    }

    public ResourceFlowableExtension(string configurationResource, string processEngineName, Consumer!ProcessEngineConfiguration configurationConsumer) {
        this.configurationResource = configurationResource;
        this.processEngineName = processEngineName;
        this.configurationConsumer = configurationConsumer;
    }

    override
    public void beforeEach(ExtensionContext context) {
        super.beforeEach(context);
        currentExtensionContext = context;
    }

    override
    public void afterEach(ExtensionContext context) throws Exception {
        super.afterEach(context);
        ProcessEngine processEngine = getProcessEngine(context);
        processEngine.close();
        processEngine = null;
    }

    override
    protected ProcessEngine getProcessEngine(ExtensionContext context) {
        return getStore(context).getOrComputeIfAbsent(context.getUniqueId(), key -> initializeProcessEngine(), ProcessEngine.class);
    }

    protected ProcessEngine initializeProcessEngine() {
        ProcessEngineConfiguration config = ProcessEngineConfiguration.createProcessEngineConfigurationFromResource(configurationResource);
        if (processEngineName !is null) {
            logger.info("Initializing process engine with name '{}'", processEngineName);
            config.setEngineName(processEngineName);
        }
        configurationConsumer.accept(config);
        ProcessEngine processEngine = config.buildProcessEngine();
        ProcessEngines.setInitialized(true);
        return processEngine;
    }

    override
    protected ExtensionContext.Store getStore(ExtensionContext context) {
        return context.getRoot().getStore(NAMESPACE);
    }

    public ProcessEngine rebootEngine() {
        string engineName = processEngineName !is null ? processEngineName : ProcessEngines.NAME_DEFAULT;
        ProcessEngine processEngine = ProcessEngines.getProcessEngine(engineName);
        ProcessEngines.unregister(processEngine);
        processEngine.close();

        ProcessEngine rebootedProcessEngine = initializeProcessEngine();
        getStore(currentExtensionContext).put(currentExtensionContext.getUniqueId(), rebootedProcessEngine);
        return rebootedProcessEngine;
    }
}
