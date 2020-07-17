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
//module flow.engine.impl.cmd.GetProcessInstanceCommentsCmd;
//
//
//import java.io.InputStream;
//import java.io.Serializable;
//
//import flow.common.api.FlowableIllegalArgumentException;
//import flow.common.interceptor.Command;
//import flow.common.interceptor.CommandContext;
//import flow.engine.impl.util.CommandContextUtil;
//import flow.engine.repository.ProcessDefinition;
//import org.slf4j.Logger;
//import org.slf4j.LoggerFactory;
//
///**
// * Gives access to a deployed process diagram, e.g., a PNG image, through a stream of bytes.
// *
// * @author Falko Menge
// */
//class GetDeploymentProcessDiagramCmd implements Command!InputStream, Serializable {
//
//    private static final long serialVersionUID = 1L;
//    private static final Logger LOGGER = LoggerFactory.getLogger(GetDeploymentProcessDiagramCmd.class);
//
//    protected string processDefinitionId;
//
//    public GetDeploymentProcessDiagramCmd(string processDefinitionId) {
//        if (processDefinitionId is null || processDefinitionId.length() < 1) {
//            throw new FlowableIllegalArgumentException("The process definition id is mandatory, but '" + processDefinitionId + "' has been provided.");
//        }
//        this.processDefinitionId = processDefinitionId;
//    }
//
//    override
//    public InputStream execute(CommandContext commandContext) {
//        ProcessDefinition processDefinition = CommandContextUtil.getProcessEngineConfiguration(commandContext).getDeploymentManager().findDeployedProcessDefinitionById(processDefinitionId);
//        string deploymentId = processDefinition.getDeploymentId();
//        string resourceName = processDefinition.getDiagramResourceName();
//        if (resourceName is null) {
//            LOGGER.info("Resource name is null! No process diagram stream exists.");
//            return null;
//        } else {
//            InputStream processDiagramStream = new GetDeploymentResourceCmd(deploymentId, resourceName).execute(commandContext);
//            return processDiagramStream;
//        }
//    }
//
//}