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

//          Copyright linse 2020. 
// Distributed under the Boost Software License, Version 1.0. 
//    (See accompanying file LICENSE_1_0.txt or copy at 
//          http://www.boost.org/LICENSE_1_0.txt)} 
 
module flow.common.api.management.TableMetaData;
 
 
 

import java.util.ArrayList;
import java.util.List;

/**
 * Structure containing meta data (column names, column types, etc.) about a certain database table.
 * 
 * @author Joram Barrez
 */
class TableMetaData {

    protected string tableName;

    protected List<string> columnNames = new ArrayList<>();

    protected List<string> columnTypes = new ArrayList<>();

    public TableMetaData() {

    }

    public TableMetaData(string tableName) {
        this.tableName = tableName;
    }

    public void addColumnMetaData(string columnName, string columnType) {
        columnNames.add(columnName);
        columnTypes.add(columnType);
    }

    public string getTableName() {
        return tableName;
    }

    public void setTableName(string tableName) {
        this.tableName = tableName;
    }

    public List<string> getColumnNames() {
        return columnNames;
    }

    public void setColumnNames(List<string> columnNames) {
        this.columnNames = columnNames;
    }

    public List<string> getColumnTypes() {
        return columnTypes;
    }

    public void setColumnTypes(List<string> columnTypes) {
        this.columnTypes = columnTypes;
    }

}
