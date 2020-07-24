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
module flow.engine.impl.cmd.GetNextIdBlockCmd;

import flow.common.db.IdBlock;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.common.persistence.entity.PropertyEntity;
import flow.engine.impl.util.CommandContextUtil;
import std.conv : to;
/**
 * @author Tom Baeyens
 */
class GetNextIdBlockCmd : Command!IdBlock {

    protected int idBlockSize;

    this(int idBlockSize) {
        this.idBlockSize = idBlockSize;
    }

    public IdBlock execute(CommandContext commandContext) {
        PropertyEntity property = cast(PropertyEntity) CommandContextUtil.getPropertyEntityManager(commandContext).findById("next.dbid");
        long oldValue = to!long(property.getValue());
        long newValue = oldValue + idBlockSize;
        property.setValue(to!string(newValue));
        CommandContextUtil.getPropertyEntityManager(commandContext).upDateDbid(property.getValue);
        return new IdBlock(oldValue, newValue - 1);
    }
}
