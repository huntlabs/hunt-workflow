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
module flow.engine.impl.persistence.deploy.DeploymentManager;


import hunt.collection.List;
import hunt.collection.Map;
import std.algorithm.searching;
import flow.bpmn.model.BpmnModel;
import flow.common.api.FlowableException;
import flow.common.api.FlowableIllegalArgumentException;
import flow.common.api.FlowableObjectNotFoundException;
import flow.common.api.deleg.event.FlowableEngineEventType;
import flow.common.api.deleg.event.FlowableEventDispatcher;
import flow.common.EngineDeployer;
import flow.common.persistence.deploy.DeploymentCache;
import flow.engine.app.AppModel;
import flow.engine.deleg.event.impl.FlowableEventBuilder;
import flow.engine.impl.ProcessDefinitionQueryImpl;
import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
import flow.engine.impl.persistence.entity.DeploymentEntity;
import flow.engine.impl.persistence.entity.DeploymentEntityManager;
import flow.engine.impl.persistence.entity.ProcessDefinitionEntity;
import flow.engine.impl.persistence.entity.ProcessDefinitionEntityManager;
import flow.engine.impl.util.CommandContextUtil;
//import flow.engine.impl.util.Flowable5Util;
import flow.engine.repository.ProcessDefinition;
import hunt.Exceptions;
import flow.engine.impl.persistence.deploy.ProcessDefinitionCacheEntry;
import flow.engine.impl.persistence.deploy.ProcessDefinitionInfoCacheObject;
import std.conv : to;
/**
 * @author Tom Baeyens
 * @author Falko Menge
 * @author Joram Barrez
 */
class DeploymentManager {

    protected DeploymentCache!ProcessDefinitionCacheEntry processDefinitionCache;
    protected DeploymentCache!ProcessDefinitionInfoCacheObject processDefinitionInfoCache;
    protected DeploymentCache!Object appResourceCache;
    protected DeploymentCache!Object knowledgeBaseCache; // Needs to be object to avoid an import to Drools in this core class
    protected List!EngineDeployer deployers;

    protected ProcessEngineConfigurationImpl processEngineConfiguration;
    protected ProcessDefinitionEntityManager processDefinitionEntityManager;
    protected DeploymentEntityManager deploymentEntityManager;

    public void deploy(DeploymentEntity deployment) {
        deploy(deployment, null);
    }

    public void deploy(DeploymentEntity deployment, Map!(string, Object) deploymentSettings) {
        foreach (EngineDeployer deployer ; deployers) {
            deployer.deploy(deployment, deploymentSettings);
        }
    }

    public ProcessDefinition findDeployedProcessDefinitionById(string processDefinitionId) {
        if (processDefinitionId.length == 0) {
            throw new FlowableIllegalArgumentException("Invalid process definition id : null");
        }

        // first try the cache
        ProcessDefinitionCacheEntry cacheEntry = processDefinitionCache.get(processDefinitionId);
        ProcessDefinition processDefinition = cacheEntry !is null ? cacheEntry.getProcessDefinition() : null;
         //ProcessDefinition processDefinition = null;
        if (processDefinition is null) {
            processDefinition = processDefinitionEntityManager.findById(processDefinitionId);
            if (processDefinition is null) {
                throw new FlowableObjectNotFoundException("no deployed process definition found with id '" ~ processDefinitionId ~ "'", typeid(ProcessDefinition));
            }
            processDefinition = resolveProcessDefinition(processDefinition).getProcessDefinition();
        }
        return processDefinition;
    }

    public ProcessDefinition findDeployedLatestProcessDefinitionByKey(string processDefinitionKey) {
        ProcessDefinition processDefinition = processDefinitionEntityManager.findLatestProcessDefinitionByKey(processDefinitionKey);

        if (processDefinition is null) {
            throw new FlowableObjectNotFoundException("no processes deployed with key '" ~ processDefinitionKey ~ "'", typeid(ProcessDefinition));
        }
        processDefinition = resolveProcessDefinition(processDefinition).getProcessDefinition();
        return processDefinition;
    }

    public ProcessDefinition findDeployedLatestProcessDefinitionByKeyAndTenantId(string processDefinitionKey, string tenantId) {
        ProcessDefinition processDefinition = processDefinitionEntityManager.findLatestProcessDefinitionByKeyAndTenantId(processDefinitionKey, tenantId);
        if (processDefinition is null) {
            throw new FlowableObjectNotFoundException("no processes deployed with key '" ~ processDefinitionKey ~ "' for tenant identifier '" ~ tenantId ~ "'", typeid(ProcessDefinition));
        }
        processDefinition = resolveProcessDefinition(processDefinition).getProcessDefinition();
        return processDefinition;
    }

    public ProcessDefinition findDeployedProcessDefinitionByKeyAndVersionAndTenantId(string processDefinitionKey, int processDefinitionVersion, string tenantId) {
        ProcessDefinition processDefinition = cast(ProcessDefinitionEntity) processDefinitionEntityManager
                .findProcessDefinitionByKeyAndVersionAndTenantId(processDefinitionKey, processDefinitionVersion, tenantId);
        if (processDefinition is null) {
            throw new FlowableObjectNotFoundException("no processes deployed with key = '" ~ processDefinitionKey ~ "' and version = '" ~ to!string(processDefinitionVersion) ~ "'", typeid(ProcessDefinition));
        }
        processDefinition = resolveProcessDefinition(processDefinition).getProcessDefinition();
        return processDefinition;
    }

    /**
     * Resolving the process definition will fetch the BPMN 2.0, parse it and store the {@link BpmnModel} in memory.
     */
    public ProcessDefinitionCacheEntry resolveProcessDefinition(ProcessDefinition processDefinition) {
        string processDefinitionId = processDefinition.getId();
        string deploymentId = processDefinition.getDeploymentId();

        ProcessDefinitionCacheEntry cachedProcessDefinition = processDefinitionCache.get(processDefinitionId);

        if (cachedProcessDefinition is null) {
            //if (Flowable5Util.isFlowable5ProcessDefinition(processDefinition, processEngineConfiguration)) {
            //    return Flowable5Util.getFlowable5CompatibilityHandler().resolveProcessDefinition(processDefinition);
            //}

            DeploymentEntity deployment = deploymentEntityManager.findById(deploymentId);
            deployment.setNew(false);
            deploy(deployment, null);
            cachedProcessDefinition = processDefinitionCache.get(processDefinitionId);

            if (cachedProcessDefinition is null) {
                throw new FlowableException("deployment '" ~ deploymentId ~ "' didn't put process definition '" ~ processDefinitionId ~ "' in the cache");
            }
        }
        return cachedProcessDefinition;
    }

    public Object getAppResourceObject(string deploymentId) {
        Object appResourceObject = appResourceCache.get(deploymentId);

        if (appResourceObject is null) {
            bool appResourcePresent = false;
            List!string deploymentResourceNames = getDeploymentEntityManager().getDeploymentResourceNames(deploymentId);
            foreach (string deploymentResourceName ; deploymentResourceNames) {
                if (endsWith(deploymentResourceName,".app")) {
                    appResourcePresent = true;
                    break;
                }
            }

            if (appResourcePresent) {
                DeploymentEntity deployment = deploymentEntityManager.findById(deploymentId);
                deployment.setNew(false);
                deploy(deployment, null);

            } else {
                throw new FlowableException("No .app resource found for deployment '" ~ deploymentId ~ "'");
            }

            appResourceObject = appResourceCache.get(deploymentId);
            if (appResourceObject is null) {
                throw new FlowableException("deployment '" ~ deploymentId ~ "' didn't put an app resource in the cache");
            }
        }

        return appResourceObject;
    }

    public AppModel getAppResourceModel(string deploymentId) {
        Object appResourceObject = getAppResourceObject(deploymentId);
        if (cast(AppModel)appResourceObject is null) {
            throw new FlowableException("App resource is not of type AppModel");
        }

        return cast(AppModel) appResourceObject;
    }

    public void removeDeployment(string deploymentId, bool cascade) {

        DeploymentEntity deployment = deploymentEntityManager.findById(deploymentId);
        if (deployment is null) {
            throw new FlowableObjectNotFoundException("Could not find a deployment with id '" ~ deploymentId ~ "'.", typeid(DeploymentEntity));
        }

        //if (Flowable5Util.isFlowable5Deployment(deployment, processEngineConfiguration)) {
        //    processEngineConfiguration.getFlowable5CompatibilityHandler().deleteDeployment(deploymentId, cascade);
        //    return;
        //}

        // Remove any process definition from the cache
        List!ProcessDefinition processDefinitions = new ProcessDefinitionQueryImpl().deploymentId(deploymentId).list();
        FlowableEventDispatcher eventDispatcher = CommandContextUtil.getProcessEngineConfiguration().getEventDispatcher();

        foreach (ProcessDefinition processDefinition ; processDefinitions) {

            // Since all process definitions are deleted by a single query, we should dispatch the events in this loop
            if (eventDispatcher !is null && eventDispatcher.isEnabled()) {
                eventDispatcher.dispatchEvent(FlowableEventBuilder.createEntityEvent(FlowableEngineEventType.ENTITY_DELETED, cast(Object)processDefinition));
            }
        }

        // Delete data
        deploymentEntityManager.deleteDeployment(deploymentId, cascade);

        // Since we use a delete by query, delete-events are not automatically dispatched
        if (eventDispatcher !is null && eventDispatcher.isEnabled()) {
            eventDispatcher.dispatchEvent(FlowableEventBuilder.createEntityEvent(FlowableEngineEventType.ENTITY_DELETED, cast(Object)deployment));
        }

        foreach (ProcessDefinition processDefinition ; processDefinitions) {
            processDefinitionCache.remove(processDefinition.getId());
            processDefinitionInfoCache.remove(processDefinition.getId());
        }

        appResourceCache.remove(deploymentId);
        knowledgeBaseCache.remove(deploymentId);
    }

    // getters and setters
    // //////////////////////////////////////////////////////

    public List!EngineDeployer getDeployers() {
        return deployers;
    }

    public void setDeployers(List!EngineDeployer deployers) {
        this.deployers = deployers;
    }

    public DeploymentCache!ProcessDefinitionCacheEntry getProcessDefinitionCache() {
        return processDefinitionCache;
    }

    public void setProcessDefinitionCache(DeploymentCache!ProcessDefinitionCacheEntry processDefinitionCache) {
        this.processDefinitionCache = processDefinitionCache;
    }

    public DeploymentCache!ProcessDefinitionInfoCacheObject getProcessDefinitionInfoCache() {
        return processDefinitionInfoCache;
    }

    public void setProcessDefinitionInfoCache(DeploymentCache!ProcessDefinitionInfoCacheObject processDefinitionInfoCache) {
        this.processDefinitionInfoCache = processDefinitionInfoCache;
    }

    public DeploymentCache!Object getKnowledgeBaseCache() {
        return knowledgeBaseCache;
    }

    public void setKnowledgeBaseCache(DeploymentCache!Object knowledgeBaseCache) {
        this.knowledgeBaseCache = knowledgeBaseCache;
    }

    public DeploymentCache!Object getAppResourceCache() {
        return appResourceCache;
    }

    public void setAppResourceCache(DeploymentCache!Object appResourceCache) {
        this.appResourceCache = appResourceCache;
    }

    public ProcessEngineConfigurationImpl getProcessEngineConfiguration() {
        return processEngineConfiguration;
    }

    public void setProcessEngineConfiguration(ProcessEngineConfigurationImpl processEngineConfiguration) {
        this.processEngineConfiguration = processEngineConfiguration;
    }

    public ProcessDefinitionEntityManager getProcessDefinitionEntityManager() {
        return processDefinitionEntityManager;
    }

    public void setProcessDefinitionEntityManager(ProcessDefinitionEntityManager processDefinitionEntityManager) {
        this.processDefinitionEntityManager = processDefinitionEntityManager;
    }

    public DeploymentEntityManager getDeploymentEntityManager() {
        return deploymentEntityManager;
    }

    public void setDeploymentEntityManager(DeploymentEntityManager deploymentEntityManager) {
        this.deploymentEntityManager = deploymentEntityManager;
    }

}
