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
//module flow.engine.impl.cmd.GetDeploymentResourceNamesCmd;
//
//import hunt.collection.List;
//
//import flow.common.api.FlowableIllegalArgumentException;
//import flow.common.interceptor.Command;
//import flow.common.interceptor.CommandContext;
//import flow.engine.impl.util.CommandContextUtil;
//
///**
// * @author Joram Barrez
// */
//class GetDeploymentResourceNamesCmd : Command!List, Serializable {
//
//    private static final long serialVersionUID = 1L;
//    protected string deploymentId;
//
//    public GetDeploymentResourceNamesCmd(string deploymentId) {
//        this.deploymentId = deploymentId;
//    }
//
//    override
//    public List execute(CommandContext commandContext) {
//        if (deploymentId is null) {
//            throw new FlowableIllegalArgumentException("deploymentId is null");
//        }
//
//        return CommandContextUtil.getDeploymentEntityManager(commandContext).getDeploymentResourceNames(deploymentId);
//    }
//
//}
