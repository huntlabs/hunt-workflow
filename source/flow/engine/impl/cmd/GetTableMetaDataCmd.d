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
module flow.engine.impl.cmd.GetTableMetaDataCmd;


import flow.common.api.FlowableIllegalArgumentException;
import flow.common.api.management.TableMetaData;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.engine.impl.util.CommandContextUtil;

/**
 * @author Joram Barrez
 */
class GetTableMetaDataCmd : Command!TableMetaData {

    protected string tableName;

    this(string tableName) {
        this.tableName = tableName;
    }

    public TableMetaData execute(CommandContext commandContext) {
        if (tableName is null) {
            throw new FlowableIllegalArgumentException("tableName is null");
        }
        return CommandContextUtil.getTableDataManager(commandContext).getTableMetaData(tableName);
    }

}
