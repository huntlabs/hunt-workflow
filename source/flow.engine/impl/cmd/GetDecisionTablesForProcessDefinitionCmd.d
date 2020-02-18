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


import java.io.Serializable;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.flowable.bpmn.model.BpmnModel;
import org.flowable.bpmn.model.FieldExtension;
import org.flowable.bpmn.model.ServiceTask;
import flow.common.api.FlowableException;
import flow.common.api.FlowableObjectNotFoundException;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import org.flowable.dmn.api.DmnDecisionTable;
import org.flowable.dmn.api.DmnDecisionTableQuery;
import org.flowable.dmn.api.DmnDeployment;
import org.flowable.dmn.api.DmnRepositoryService;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.impl.util.ProcessDefinitionUtil;
import flow.engine.repository.Deployment;
import flow.engine.repository.ProcessDefinition;

/**
 * @author Yvo Swillens
 */
class GetDecisionTablesForProcessDefinitionCmd implements Command<List<DmnDecisionTable>>, Serializable {

    private static final long serialVersionUID = 1L;
    protected string processDefinitionId;
    protected DmnRepositoryService dmnRepositoryService;

    public GetDecisionTablesForProcessDefinitionCmd(string processDefinitionId) {
        this.processDefinitionId = processDefinitionId;
    }

    @Override
    public List<DmnDecisionTable> execute(CommandContext commandContext) {
        ProcessDefinition processDefinition = ProcessDefinitionUtil.getProcessDefinition(processDefinitionId);

        if (processDefinition is null) {
            throw new FlowableObjectNotFoundException("Cannot find process definition for id: " + processDefinitionId, ProcessDefinition.class);
        }

        BpmnModel bpmnModel = ProcessDefinitionUtil.getBpmnModel(processDefinitionId);

        if (bpmnModel is null) {
            throw new FlowableObjectNotFoundException("Cannot find bpmn model for process definition id: " + processDefinitionId, BpmnModel.class);
        }

        if (CommandContextUtil.getDmnRepositoryService() is null) {
            throw new FlowableException("DMN repository service is not available");
        }

        dmnRepositoryService = CommandContextUtil.getDmnRepositoryService();
        List<DmnDecisionTable> decisionTables = getDecisionTablesFromModel(bpmnModel, processDefinition);

        return decisionTables;
    }

    protected List<DmnDecisionTable> getDecisionTablesFromModel(BpmnModel bpmnModel, ProcessDefinition processDefinition) {
        Set<string> decisionTableKeys = new HashSet<>();
        List<DmnDecisionTable> decisionTables = new ArrayList<>();
        List<ServiceTask> serviceTasks = bpmnModel.getMainProcess().findFlowElementsOfType(ServiceTask.class, true);

        for (ServiceTask serviceTask : serviceTasks) {
            if ("dmn".equals(serviceTask.getType())) {
                if (serviceTask.getFieldExtensions() !is null && serviceTask.getFieldExtensions().size() > 0) {
                    for (FieldExtension fieldExtension : serviceTask.getFieldExtensions()) {
                        if ("decisionTableReferenceKey".equals(fieldExtension.getFieldName())) {
                            string decisionTableReferenceKey = fieldExtension.getStringValue();
                            if (!decisionTableKeys.contains(decisionTableReferenceKey)) {
                                addDecisionTableToCollection(decisionTables, decisionTableReferenceKey, processDefinition);
                                decisionTableKeys.add(decisionTableReferenceKey);
                            }
                            break;
                        }
                    }
                }
            }
        }

        return decisionTables;
    }

    protected void addDecisionTableToCollection(List<DmnDecisionTable> decisionTables, string decisionTableKey, ProcessDefinition processDefinition) {
        DmnDecisionTableQuery decisionTableQuery = dmnRepositoryService.createDecisionTableQuery().decisionTableKey(decisionTableKey);
        Deployment deployment = CommandContextUtil.getDeploymentEntityManager().findById(processDefinition.getDeploymentId());
        if (deployment.getParentDeploymentId() !is null) {
            List<DmnDeployment> dmnDeployments = dmnRepositoryService.createDeploymentQuery().parentDeploymentId(deployment.getParentDeploymentId()).list();
            
            if (dmnDeployments !is null && dmnDeployments.size() > 0) {
                decisionTableQuery.deploymentId(dmnDeployments.get(0).getId());
            } else {
                decisionTableQuery.latestVersion();
            }
            
        } else {
            decisionTableQuery.latestVersion();
        }
        
        DmnDecisionTable decisionTable = decisionTableQuery.singleResult();
        
        if (decisionTable !is null) {
            decisionTables.add(decisionTable);
        }
    }
}
