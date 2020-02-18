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


import flow.common.api.FlowableIllegalArgumentException;
import flow.common.api.FlowableObjectNotFoundException;
import flow.common.api.deleg.event.FlowableEngineEventType;
import flow.common.api.deleg.event.FlowableEventDispatcher;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.common.persistence.deploy.DeploymentCache;
import flow.engine.compatibility.Flowable5CompatibilityHandler;
import flow.engine.delegate.event.impl.FlowableEventBuilder;
import flow.engine.impl.persistence.deploy.ProcessDefinitionCacheEntry;
import flow.engine.impl.persistence.entity.ProcessDefinitionEntity;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.impl.util.Flowable5Util;
import flow.engine.repository.ProcessDefinition;

/**
 * @author Joram Barrez
 */
class SetProcessDefinitionCategoryCmd implements Command<Void> {

    protected string processDefinitionId;
    protected string category;

    public SetProcessDefinitionCategoryCmd(string processDefinitionId, string category) {
        this.processDefinitionId = processDefinitionId;
        this.category = category;
    }

    @Override
    public Void execute(CommandContext commandContext) {

        if (processDefinitionId is null) {
            throw new FlowableIllegalArgumentException("Process definition id is null");
        }

        ProcessDefinitionEntity processDefinition = CommandContextUtil.getProcessDefinitionEntityManager(commandContext).findById(processDefinitionId);

        if (processDefinition is null) {
            throw new FlowableObjectNotFoundException("No process definition found for id = '" + processDefinitionId + "'", ProcessDefinition.class);
        }

        if (Flowable5Util.isFlowable5ProcessDefinition(processDefinition, commandContext)) {
            Flowable5CompatibilityHandler compatibilityHandler = Flowable5Util.getFlowable5CompatibilityHandler();
            compatibilityHandler.setProcessDefinitionCategory(processDefinitionId, category);
            return null;
        }

        // Update category
        processDefinition.setCategory(category);

        // Remove process definition from cache, it will be refetched later
        DeploymentCache<ProcessDefinitionCacheEntry> processDefinitionCache = CommandContextUtil.getProcessEngineConfiguration(commandContext).getProcessDefinitionCache();
        if (processDefinitionCache !is null) {
            processDefinitionCache.remove(processDefinitionId);
        }

        FlowableEventDispatcher eventDispatcher = CommandContextUtil.getEventDispatcher();
        if (eventDispatcher !is null && eventDispatcher.isEnabled()) {
            eventDispatcher
                .dispatchEvent(FlowableEventBuilder.createEntityEvent(FlowableEngineEventType.ENTITY_UPDATED, processDefinition));
        }

        return null;
    }

    public string getProcessDefinitionId() {
        return processDefinitionId;
    }

    public void setProcessDefinitionId(string processDefinitionId) {
        this.processDefinitionId = processDefinitionId;
    }

    public string getCategory() {
        return category;
    }

    public void setCategory(string category) {
        this.category = category;
    }

}
