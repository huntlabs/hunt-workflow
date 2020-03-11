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

module flow.idm.engine.impl.cmd.CreatePrivilegeCmd;


import flow.common.api.FlowableIllegalArgumentException;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.idm.api.Privilege;
import flow.idm.engine.impl.persistence.entity.PrivilegeEntity;
import flow.idm.engine.impl.util.CommandContextUtil;
import hunt.Exceptions;
/**
 * @author Joram Barrez
 */
class CreatePrivilegeCmd : Command!Privilege {


    protected string name;

    this(string name) {
        if (name is null) {
            throw new FlowableIllegalArgumentException("Privilege name is null");
        }
        this.name = name;
    }

    public Privilege execute(CommandContext commandContext) {
        implementationMissing(false);
        return null;
        //long count = CommandContextUtil.getPrivilegeEntityManager(commandContext).createNewPrivilegeQuery().privilegeName(name).count();
        //if (count > 0) {
        //    throw new FlowableIllegalArgumentException("Provided privilege name already exists");
        //}
        //
        //PrivilegeEntity entity = CommandContextUtil.getPrivilegeEntityManager(commandContext).create();
        //entity.setName(name);
        //CommandContextUtil.getPrivilegeEntityManager(commandContext).insert(entity);
        //return entity;
    }
}
