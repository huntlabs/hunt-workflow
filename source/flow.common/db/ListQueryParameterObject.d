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

module flow.common.db.ListQueryParameterObject;

import std.array;
import hunt.collection.Map;
import hunt.collection.HashMap;
import flow.common.api.query.Query;
import flow.common.api.query.QueryProperty;
import flow.common.AbstractEngineConfiguration;
import flow.common.Direction;
import hunt.Integer;
/**
 * @author Tijs Rademakers
 * @author Joram Barrez
 */
class ListQueryParameterObject {

    public static enum ResultType {
        LIST, LIST_PAGE, SINGLE_RESULT, COUNT
    }

    public static  string SORTORDER_ASC = "asc";
    public static  string SORTORDER_DESC = "desc";

    protected int firstResult = -1;
    protected int maxResults = -1;
    protected Object parameter;
    protected string orderByColumns;
    protected Map!(string, bool) orderByColumnMap  ;//= new TreeMap<>();
    protected QueryProperty orderProperty;
    protected string nullHandlingColumn;
    protected NullHandlingOnOrder nullHandlingOnOrder;
    protected ResultType resultType;
    protected string databaseType;

    this() {
      orderByColumnMap = new HashMap!(string,bool);
    }

    this(Object parameter, int firstResult, int maxResults) {
        this.parameter = parameter;
        this.firstResult = firstResult;
        this.maxResults = maxResults;
    }

    protected void addOrder(string column, string sortOrder, NullHandlingOnOrder nullHandlingOnOrder) {

        if (orderByColumns is null) {
            orderByColumns = "";
        } else {
            orderByColumns = orderByColumns ~ ", ";
        }

        if (Direction.ASCENDING.getName() == (sortOrder)) {
            orderByColumnMap.put(column, true);
        } else {
            orderByColumnMap.put(column, false);
        }

        string defaultOrderByClause = column ~ " " ~ sortOrder;

      //  if (nullHandlingOnOrder !is null) {

            if (nullHandlingOnOrder == NullHandlingOnOrder.NULLS_FIRST) {

                if (AbstractEngineConfiguration.DATABASE_TYPE_H2 == (databaseType)
                        || AbstractEngineConfiguration.DATABASE_TYPE_HSQL == (databaseType)
                        || AbstractEngineConfiguration.DATABASE_TYPE_POSTGRES == (databaseType)
                        || AbstractEngineConfiguration.DATABASE_TYPE_ORACLE == (databaseType)) {
                    orderByColumns = orderByColumns ~ defaultOrderByClause ~ " NULLS FIRST";
                } else if (AbstractEngineConfiguration.DATABASE_TYPE_MYSQL == (databaseType)) {
                    orderByColumns = orderByColumns ~ "isnull(" ~ column ~ ") desc," ~ defaultOrderByClause;
                } else if (AbstractEngineConfiguration.DATABASE_TYPE_DB2 == (databaseType) || AbstractEngineConfiguration.DATABASE_TYPE_MSSQL == (databaseType)) {
                    if (nullHandlingColumn is null) {
                        nullHandlingColumn = "";
                    } else {
                        nullHandlingColumn = nullHandlingColumn ~ ", ";
                    }
                    string columnName = column.replace("RES.", "") ~ "_order_null";
                    nullHandlingColumn = nullHandlingColumn ~ "case when " ~ column ~ " is null then 0 else 1 end " ~ columnName;
                    orderByColumns = orderByColumns ~ columnName ~ "," ~ defaultOrderByClause;
                } else {
                    orderByColumns = orderByColumns ~ defaultOrderByClause;
                }

            } else if (nullHandlingOnOrder == NullHandlingOnOrder.NULLS_LAST) {

                if (AbstractEngineConfiguration.DATABASE_TYPE_H2 == (databaseType)
                        || AbstractEngineConfiguration.DATABASE_TYPE_HSQL == (databaseType)
                        || AbstractEngineConfiguration.DATABASE_TYPE_POSTGRES == (databaseType)
                        || AbstractEngineConfiguration.DATABASE_TYPE_ORACLE == (databaseType)) {
                    orderByColumns = orderByColumns ~ column ~ " " ~ sortOrder ~ " NULLS LAST";
                } else if (AbstractEngineConfiguration.DATABASE_TYPE_MYSQL == (databaseType)) {
                    orderByColumns = orderByColumns ~ "isnull(" ~ column ~ ") asc," ~ defaultOrderByClause;
                } else if (AbstractEngineConfiguration.DATABASE_TYPE_DB2 == (databaseType) || AbstractEngineConfiguration.DATABASE_TYPE_MSSQL == (databaseType)) {
                    if (nullHandlingColumn is null) {
                        nullHandlingColumn = "";
                    } else {
                        nullHandlingColumn = nullHandlingColumn ~ ", ";
                    }
                    string columnName = column.replace("RES.", "") ~ "_order_null";
                    nullHandlingColumn = nullHandlingColumn ~ "case when " ~ column ~ " is null then 1 else 0 end " ~ columnName;
                    orderByColumns = orderByColumns ~ columnName ~ "," ~ defaultOrderByClause;
                } else {
                    orderByColumns = orderByColumns ~ defaultOrderByClause;
                }

            }

        //}
        //else {
        //    orderByColumns = orderByColumns ~ defaultOrderByClause;
        //}

    }

    public int getFirstResult() {
        return firstResult;
    }

    public int getFirstRow() {
        return firstResult + 1;
    }

    public int getLastRow() {
        if (maxResults == Integer.MAX_VALUE) {
            return maxResults;
        }
        return firstResult + maxResults + 1;
    }

    public int getMaxResults() {
        return maxResults;
    }

    public Object getParameter() {
        return parameter;
    }

    public void setFirstResult(int firstResult) {
        this.firstResult = firstResult;
    }

    public void setMaxResults(int maxResults) {
        this.maxResults = maxResults;
    }

    public void setParameter(Object parameter) {
        this.parameter = parameter;
    }

    public string getOrderBy() {
        // For db2 and sqlserver, when there is paging needed, the limitBefore and limitBetween is used.
        // For those databases, the regular orderBy needs to be empty,
        // the order will be added in the 'limitBetween' (see mssql/db2.properties).
        if (firstResult >= 0
                && (AbstractEngineConfiguration.DATABASE_TYPE_DB2 == (databaseType) || AbstractEngineConfiguration.DATABASE_TYPE_MSSQL == (databaseType)) ) {
            return "";
        } else {
            return "order by " ~ getOrderByColumns();
        }
    }

    public void setOrderByColumns(string orderByColumns) {
        this.orderByColumns = orderByColumns;
    }

    public string getOrderByColumns() {
        if (orderByColumns !is null) {
            return orderByColumns;
        } else {
            return "RES.ID_ asc";
        }
    }

    public Map!(string, bool) getOrderByColumnMap() {
        return orderByColumnMap;
    }

    public void setDatabaseType(string databaseType) {
        this.databaseType = databaseType;
    }

    public string getDatabaseType() {
        return databaseType;
    }

    public string getNullHandlingColumn() {
        return nullHandlingColumn;
    }

    public void setNullHandlingColumn(string nullHandlingColumn) {
        this.nullHandlingColumn = nullHandlingColumn;
    }

}
