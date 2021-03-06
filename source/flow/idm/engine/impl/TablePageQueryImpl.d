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

module flow.idm.engine.impl.TablePageQueryImpl;

import flow.common.api.management.TablePage;
import flow.common.api.management.TablePageQuery;
import flow.common.query.AbstractQuery;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.common.interceptor.CommandExecutor;
import flow.idm.engine.impl.util.CommandContextUtil;

/**
 *
 * @author Joram Barrez
 */
class TablePageQueryImpl : TablePageQuery, Command!TablePage {


    public CommandExecutor commandExecutor;

    protected string _tableName;
    protected string order;
    protected int firstResult;
    protected int maxResults;

    this() {
    }

    this(CommandExecutor commandExecutor) {
        this.commandExecutor = commandExecutor;
    }


    public TablePageQueryImpl tableName(string tableName) {
        this._tableName = tableName;
        return this;
    }


    public TablePageQueryImpl orderAsc(string column) {
        addOrder(column, "asc");
        return this;
    }


    public TablePageQueryImpl orderDesc(string column) {
        addOrder(column, "desc");
        return this;
    }

    public string getTableName() {
        return _tableName;
    }

    protected void addOrder(string column, string sortOrder) {
        if (order is null) {
            order = "";
        } else {
            order = order ~ ", ";
        }
        order = order ~ column ~ " " ~ sortOrder;
    }


    public TablePage listPage(int firstResult, int maxResults) {
        this.firstResult = firstResult;
        this.maxResults = maxResults;
        return cast(TablePage)(commandExecutor.execute(this));
    }


    public TablePage execute(CommandContext commandContext) {
        return CommandContextUtil.getTableDataManager(commandContext).getTablePage(this, firstResult, maxResults);
    }

    public string getOrder() {
        return order;
    }

}
