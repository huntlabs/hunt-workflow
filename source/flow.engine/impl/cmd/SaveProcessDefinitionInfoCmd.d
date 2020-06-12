///* Licensed under the Apache License, Version 2.0 (the "License");
// * you may not use this file except in compliance with the License.
// * You may obtain a copy of the License at
// *
// *      http://www.apache.org/licenses/LICENSE-2.0
// *
// * Unless required by applicable law or agreed to in writing, software
// * distributed under the License is distributed on an "AS IS" BASIS,
// * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// * See the License for the specific language governing permissions and
// * limitations under the License.
// */
//module flow.engine.impl.cmd.SaveProcessDefinitionInfoCmd;
//
//
//import flow.common.api.FlowableException;
//import flow.common.api.FlowableIllegalArgumentException;
//import flow.common.interceptor.Command;
//import flow.common.interceptor.CommandContext;
//import flow.engine.impl.persistence.entity.ProcessDefinitionInfoEntity;
//import flow.engine.impl.persistence.entity.ProcessDefinitionInfoEntityManager;
//import flow.engine.impl.util.CommandContextUtil;
//import hunt.Object;
////import com.fasterxml.jackson.databind.ObjectWriter;
////import com.fasterxml.jackson.databind.node.ObjectNode;
//
///**
// * @author Tijs Rademakers
// */
//class SaveProcessDefinitionInfoCmd : Command!Void {
//
//
//    protected string processDefinitionId;
//    protected ObjectNode infoNode;
//
//    public SaveProcessDefinitionInfoCmd(string processDefinitionId, ObjectNode infoNode) {
//        this.processDefinitionId = processDefinitionId;
//        this.infoNode = infoNode;
//    }
//
//    override
//    public Void execute(CommandContext commandContext) {
//        if (processDefinitionId is null) {
//            throw new FlowableIllegalArgumentException("process definition id is null");
//        }
//
//        if (infoNode is null) {
//            throw new FlowableIllegalArgumentException("process definition info node is null");
//        }
//
//        ProcessDefinitionInfoEntityManager definitionInfoEntityManager = CommandContextUtil.getProcessDefinitionInfoEntityManager(commandContext);
//        ProcessDefinitionInfoEntity definitionInfoEntity = definitionInfoEntityManager.findProcessDefinitionInfoByProcessDefinitionId(processDefinitionId);
//        if (definitionInfoEntity is null) {
//            definitionInfoEntity = definitionInfoEntityManager.create();
//            definitionInfoEntity.setProcessDefinitionId(processDefinitionId);
//            CommandContextUtil.getProcessDefinitionInfoEntityManager().insertProcessDefinitionInfo(definitionInfoEntity);
//        }
//
//        try {
//            ObjectWriter writer = CommandContextUtil.getProcessEngineConfiguration(commandContext).getObjectMapper().writer();
//            CommandContextUtil.getProcessDefinitionInfoEntityManager().updateInfoJson(definitionInfoEntity.getId(), writer.writeValueAsBytes(infoNode));
//        } catch (Exception e) {
//            throw new FlowableException("Unable to serialize info node " + infoNode, e);
//        }
//
//        return null;
//    }
//
//}
