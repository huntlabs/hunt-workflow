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

module flow.idm.engine.impl.cmd.GetUsersWithPrivilegeCmd;

import hunt.collection.List;

import flow.common.api.FlowableIllegalArgumentException;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.idm.api.User;
import flow.idm.engine.impl.util.CommandContextUtil;
import hunt.Exceptions;
/**
 * @author Joram Barrez
 */
class GetUsersWithPrivilegeCmd : Command!(List!User) {


    protected string name;

    this(string name) {
        if (name is null) {
            throw new FlowableIllegalArgumentException("name is null");
        }
        this.name = name;
    }

    public List!User execute(CommandContext commandContext) {
        implementationMissing(false);
        return null;
       // return CommandContextUtil.getUserEntityManager(commandContext).findUsersByPrivilegeId(name);
    }
}
