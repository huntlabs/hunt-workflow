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

module flow.idm.engine.impl.persistence.entity.TableDataManager;

import hunt.collection.List;
import hunt.collection.Map;

import flow.common.api.management.TableMetaData;
import flow.common.api.management.TablePage;
import flow.idm.engine.impl.TablePageQueryImpl;

/**
 * @author Joram Barrez
 */
interface TableDataManager {

    Map!(string, long) getTableCount();

    List!string getTablesPresentInDatabase();

    TablePage getTablePage(TablePageQueryImpl tablePageQuery, int firstResult, int maxResults);

    string getTableName(TypeInfo entityClass, bool withPrefix);

    TableMetaData getTableMetaData(string tableName);

}
