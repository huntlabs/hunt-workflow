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



import java.util.Date;

import flow.common.interceptor.EngineConfigurationConstants;
import flow.engine.FormService;
import flow.engine.HistoryService;
import flow.engine.IdentityService;
import flow.engine.ManagementService;
import flow.engine.ProcessEngine;
import flow.engine.RepositoryService;
import flow.engine.RuntimeService;
import flow.engine.TaskService;
import flow.engine.impl.ProcessEngineImpl;
import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
import flow.engine.impl.test.TestHelper;
import flow.engine.test.mock.FlowableMockSupport;
import org.flowable.eventregistry.api.EventRegistry;
import org.flowable.eventregistry.api.EventRepositoryService;
import org.flowable.eventregistry.impl.EventRegistryEngineConfiguration;

import junit.framework.TestCase;

/**
 * Convenience for ProcessEngine and services initialization in the form of a JUnit base class.
 * 
 * <p>
 * Usage: <code>class YourTest extends FlowableTestCase</code>
 * </p>
 * 
 * <p>
 * The ProcessEngine and the services available to subclasses through protected member fields. The processEngine will be initialized by default with the flowable.cfg.xml resource on the classpath. To
 * specify a different configuration file, override the {@link #getConfigurationResource()} method. Process engines will be cached statically. The first time the setUp is called for a given
 * configuration resource, the process engine will be constructed.
 * </p>
 * 
 * <p>
 * You can declare a deployment with the {@link Deployment} annotation. This base class will make sure that this deployment gets deployed in the setUp and
 * {@link RepositoryService#deleteDeploymentCascade(string, bool) cascade deleted} in the tearDown.
 * </p>
 * 
 * <p>
 * This class also lets you {@link #setCurrentTime(Date) set the current time used by the process engine}. This can be handy to control the exact time that is used by the engine in order to verify
 * e.g. e.g. due dates of timers. Or start, end and duration times in the history service. In the tearDown, the internal clock will automatically be reset to use the current system time rather then
 * the time that was set during a test method.
 * </p>
 * 
 * @author Tom Baeyens
 */
abstract class FlowableTestCase extends TestCase {

    protected string configurationResource = "flowable.cfg.xml";
    protected string deploymentId;

    protected ProcessEngineConfigurationImpl processEngineConfiguration;
    protected ProcessEngine processEngine;
    protected RepositoryService repositoryService;
    protected RuntimeService runtimeService;
    protected TaskService taskService;
    protected HistoryService historicDataService;
    protected IdentityService identityService;
    protected ManagementService managementService;
    protected FormService formService;

    private FlowableMockSupport mockSupport;

    /** uses 'flowable.cfg.xml' as it's configuration resource */
    public FlowableTestCase() {
    }

    public void assertProcessEnded(final string processInstanceId) {
        TestHelper.assertProcessEnded(processEngine, processInstanceId);
    }

    @Override
    protected void setUp() throws Exception {
        super.setUp();

        if (processEngine is null) {
            initializeProcessEngine();
        }
        
        initializeServices();
        initializeMockSupport();
    }

    @Override
    protected void runTest() throws Throwable {

        // Support for mockup annotations on test method
        TestHelper.annotationMockSupportSetup(getClass(), getName(), mockSupport);

        // The deployment of processes denoted by @Deployment should
        // be done after the setup(). After all, the mockups must be
        // configured in the engine before the actual deployment happens
        deploymentId = TestHelper.annotationDeploymentSetUp(processEngine, getClass(), getName());

        super.runTest();

        // Remove deployment
        TestHelper.annotationDeploymentTearDown(processEngine, deploymentId, getClass(), getName());

        // Reset mocks
        TestHelper.annotationMockSupportTeardown(mockSupport);
    }

    protected void initializeProcessEngine() {
        processEngine = TestHelper.getProcessEngine(getConfigurationResource());
    }

    protected void initializeServices() {
        processEngineConfiguration = ((ProcessEngineImpl) processEngine).getProcessEngineConfiguration();
        repositoryService = processEngine.getRepositoryService();
        runtimeService = processEngine.getRuntimeService();
        taskService = processEngine.getTaskService();
        historicDataService = processEngine.getHistoryService();
        identityService = processEngine.getIdentityService();
        managementService = processEngine.getManagementService();
        formService = processEngine.getFormService();
    }

    protected void initializeMockSupport() {
        if (FlowableMockSupport.isMockSupportPossible(processEngine)) {
            this.mockSupport = new FlowableMockSupport(processEngine);
        }
    }
    
    protected EventRepositoryService getEventRepositoryService() {
        return getEventRegistryEngineConfiguration().getEventRepositoryService();
    }
    
    protected EventRegistry getEventRegistry() {
        return getEventRegistryEngineConfiguration().getEventRegistry();
    }
    
    protected EventRegistryEngineConfiguration getEventRegistryEngineConfiguration() {
        return (EventRegistryEngineConfiguration) processEngineConfiguration.getEngineConfigurations()
                        .get(EngineConfigurationConstants.KEY_EVENT_REGISTRY_CONFIG);
    }

    @Override
    protected void tearDown() throws Exception {

        // Reset any timers
        processEngineConfiguration.getClock().reset();

        // Reset any mocks
        if (mockSupport !is null) {
            mockSupport.reset();
        }

        super.tearDown();
    }

    public static void closeProcessEngines() {
        TestHelper.closeProcessEngines();
    }

    public void setCurrentTime(Date currentTime) {
        processEngineConfiguration.getClock().setCurrentTime(currentTime);
    }

    public string getConfigurationResource() {
        return configurationResource;
    }

    public void setConfigurationResource(string configurationResource) {
        this.configurationResource = configurationResource;
    }

    public FlowableMockSupport getMockSupport() {
        return mockSupport;
    }

    public FlowableMockSupport mockSupport() {
        return mockSupport;
    }

}
