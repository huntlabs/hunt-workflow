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
module flow.idm.engine.impl.cmd.SaveGroupCmd;


import flow.common.api.FlowableIllegalArgumentException;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.common.persistence.entity.Entity;
import flow.idm.api.Group;
import flow.idm.engine.impl.persistence.entity.GroupEntity;
import flow.idm.engine.impl.util.CommandContextUtil;
import hunt.Object;
import hunt.Exceptions;
/**
 * @author Joram Barrez
 */
class SaveGroupCmd : Command!Void {

    protected Group group;

    this(Group group) {
        this.group = group;
    }

    public Void execute(CommandContext commandContext) {
        implementationMissing(false);
        //if (group is null) {
        //    throw new FlowableIllegalArgumentException("group is null");
        //}
        //
        //if (CommandContextUtil.getGroupEntityManager(commandContext).isNewGroup(group)) {
        //    if (group instanceof GroupEntity) {
        //        CommandContextUtil.getGroupEntityManager(commandContext).insert((GroupEntity) group);
        //    } else {
        //        CommandContextUtil.getDbSqlSession(commandContext).insert((Entity) group);
        //    }
        //} else {
        //    if (group instanceof GroupEntity) {
        //        CommandContextUtil.getGroupEntityManager(commandContext).update((GroupEntity) group);
        //    } else {
        //        CommandContextUtil.getDbSqlSession(commandContext).update((Entity) group);
        //    }
        //
        //}
        return null;
    }

}
