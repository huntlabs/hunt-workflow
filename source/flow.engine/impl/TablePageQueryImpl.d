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


import java.io.Serializable;

import flow.common.api.management.TablePage;
import flow.common.api.management.TablePageQuery;
import flow.common.db.ListQueryParameterObject;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.common.interceptor.CommandExecutor;
import flow.engine.impl.util.CommandContextUtil;

/**
 *
 * @author Joram Barrez
 */
class TablePageQueryImpl implements TablePageQuery, Command!TablePage, Serializable {

    private static final long serialVersionUID = 1L;

    transient CommandExecutor commandExecutor;

    protected string tableName;
    protected string order;
    protected int firstResult;
    protected int maxResults;

    public TablePageQueryImpl() {
    }

    public TablePageQueryImpl(CommandExecutor commandExecutor) {
        this.commandExecutor = commandExecutor;
    }

    override
    public TablePageQueryImpl tableName(string tableName) {
        this.tableName = tableName;
        return this;
    }

    override
    public TablePageQueryImpl orderAsc(string column) {
        addOrder(column, ListQueryParameterObject.SORTORDER_ASC);
        return this;
    }

    override
    public TablePageQueryImpl orderDesc(string column) {
        addOrder(column, ListQueryParameterObject.SORTORDER_DESC);
        return this;
    }

    public string getTableName() {
        return tableName;
    }

    protected void addOrder(string column, string sortOrder) {
        if (order is null) {
            order = "";
        } else {
            order = order + ", ";
        }
        order = order + column + " " + sortOrder;
    }

    override
    public TablePage listPage(int firstResult, int maxResults) {
        this.firstResult = firstResult;
        this.maxResults = maxResults;
        return commandExecutor.execute(this);
    }

    override
    public TablePage execute(CommandContext commandContext) {
        return CommandContextUtil.getTableDataManager(commandContext).getTablePage(this, firstResult, maxResults);
    }

    public string getOrder() {
        return order;
    }

}
