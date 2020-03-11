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

module flow.idm.engine.impl.cmd.DeleteGroupCmd;


import flow.common.api.FlowableIllegalArgumentException;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.idm.engine.impl.util.CommandContextUtil;
import hunt.Object;
import hunt.Exceptions;
/**
 * @author Tom Baeyens
 */
class DeleteGroupCmd : Command!Void {

    string groupId;

    this(string groupId) {
        this.groupId = groupId;
    }

    public Void execute(CommandContext commandContext) {
        implementationMissing(false);
        //if (groupId is null) {
        //    throw new FlowableIllegalArgumentException("groupId is null");
        //}
        //CommandContextUtil.getGroupEntityManager(commandContext).delete(groupId);

        return null;
    }

}
