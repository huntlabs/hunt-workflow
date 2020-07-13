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

module flow.idm.engine.impl.cmd.GetPrivilegeMappingsByPrivilegeIdCmd;

import hunt.collection.List;

import flow.common.api.FlowableIllegalArgumentException;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.idm.api.PrivilegeMapping;
import flow.idm.engine.impl.util.CommandContextUtil;
import hunt.Exceptions;
/**
 * @author Tijs Rademakers
 */
class GetPrivilegeMappingsByPrivilegeIdCmd : Command!(List!PrivilegeMapping) {


    protected string privilegeId;

    this(string privilegeId) {
        if (privilegeId is null) {
            throw new FlowableIllegalArgumentException("privilegeId is null");
        }
        this.privilegeId = privilegeId;
    }

    public List!PrivilegeMapping execute(CommandContext commandContext) {
        implementationMissing(false);
        return null;
       // return CommandContextUtil.getPrivilegeMappingEntityManager(commandContext).getPrivilegeMappingsByPrivilegeId(privilegeId);
    }
}
