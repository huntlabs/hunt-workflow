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
module flow.idm.engine.impl.cmd.DeletePrivilegeMappingCmd;



import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.idm.engine.impl.persistence.entity.PrivilegeMappingEntityManager;
import flow.idm.engine.impl.util.CommandContextUtil;
import hunt.Object;
import hunt.Exceptions;

class DeletePrivilegeMappingCmd : Command!Void {

    protected string privilegeId;
    protected string userId;
    protected string groupId;

    this(string privilegeId, string userId, string groupId) {
        this.privilegeId = privilegeId;
        this.userId = userId;
        this.groupId = groupId;
    }

    public Void execute(CommandContext commandContext) {
        implementationMissing(false);
        return null;
        //PrivilegeMappingEntityManager privilegeMappingEntityManager = CommandContextUtil.getPrivilegeMappingEntityManager(commandContext);
        //if (userId !is null) {
        //    privilegeMappingEntityManager.deleteByPrivilegeIdAndUserId(privilegeId, userId);
        //} else if (groupId !is null) {
        //    privilegeMappingEntityManager.deleteByPrivilegeIdAndGroupId(privilegeId, groupId);
        //}
        //
        //return null;
    }
}
