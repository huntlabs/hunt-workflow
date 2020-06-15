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

module flow.engine.impl.cmd.StartProcessInstanceByMessageCmd;

import hunt.collection.Map;

import flow.common.api.FlowableException;
import flow.common.api.FlowableIllegalArgumentException;
import flow.common.api.FlowableObjectNotFoundException;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.engine.impl.persistence.deploy.DeploymentManager;
import flow.engine.impl.runtime.ProcessInstanceBuilderImpl;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.impl.util.ProcessInstanceHelper;
import flow.engine.repository.ProcessDefinition;
import flow.engine.runtime.ProcessInstance;
import flow.eventsubscription.service.impl.persistence.entity.MessageEventSubscriptionEntity;

/**
 * @author Joram Barrez
 * @author Tijs Rademakers
 */
class StartProcessInstanceByMessageCmd : Command!ProcessInstance {

    protected string messageName;
    protected string businessKey;
    protected Map!(string, Object) processVariables;
    protected Map!(string, Object) transientVariables;
    protected string callbackId;
    protected string callbackType;
    protected string referenceId;
    protected string referenceType;
    protected string tenantId;

    this(string messageName, string businessKey, Map!(string, Object) processVariables, string tenantId) {
        this.messageName = messageName;
        this.businessKey = businessKey;
        this.processVariables = processVariables;
        this.tenantId = tenantId;
    }

    this(ProcessInstanceBuilderImpl processInstanceBuilder) {
        this(processInstanceBuilder.getMessageName(),
             processInstanceBuilder.getBusinessKey(),
             processInstanceBuilder.getVariables(),
             processInstanceBuilder.getTenantId());
        this.transientVariables = processInstanceBuilder.getTransientVariables();
        this.callbackId = processInstanceBuilder.getCallbackId();
        this.callbackType = processInstanceBuilder.getCallbackType();
        this.referenceId = processInstanceBuilder.getReferenceId();
        this.referenceType = processInstanceBuilder.getReferenceType();
    }

    public ProcessInstance execute(CommandContext commandContext) {

        if (messageName is null) {
            throw new FlowableIllegalArgumentException("Cannot start process instance by message: message name is null");
        }

        MessageEventSubscriptionEntity messageEventSubscription = CommandContextUtil.getEventSubscriptionService(commandContext).findMessageStartEventSubscriptionByName(messageName, tenantId);

        if (messageEventSubscription is null) {
            throw new FlowableObjectNotFoundException("Cannot start process instance by message: no subscription to message with name '" ~ messageName ~ "' found.");
        }

        string processDefinitionId = messageEventSubscription.getConfiguration();
        if (processDefinitionId is null) {
            throw new FlowableException("Cannot start process instance by message: subscription to message with name '" ~ messageName ~ "' is not a message start event.");
        }

        DeploymentManager deploymentCache = CommandContextUtil.getProcessEngineConfiguration(commandContext).getDeploymentManager();

        ProcessDefinition processDefinition = deploymentCache.findDeployedProcessDefinitionById(processDefinitionId);
        if (processDefinition is null) {
            throw new FlowableObjectNotFoundException("No process definition found for id '" ~ processDefinitionId ~ "'");
        }

        ProcessInstanceHelper processInstanceHelper = CommandContextUtil.getProcessEngineConfiguration(commandContext).getProcessInstanceHelper();
        ProcessInstance processInstance = processInstanceHelper.createAndStartProcessInstanceByMessage(processDefinition,
            messageName, businessKey, processVariables, transientVariables, callbackId, callbackType, referenceId, referenceType);

        return processInstance;
    }

}
