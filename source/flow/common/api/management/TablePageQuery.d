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

module flow.common.api.management.TablePageQuery;




import flow.common.api.management.TablePage;

/**
 * Allows programmatic querying of {@link TablePage}s.
 *
 * @author Joram Barrez
 */
interface TablePageQuery {

    /**
     * The name of the table of which a page must be fetched.
     */
    TablePageQuery tableName(string tableName);

    /**
     * Orders the resulting table page rows by the given column in ascending order.
     */
    TablePageQuery orderAsc(string column);

    /**
     * Orders the resulting table page rows by the given column in descending order.
     */
    TablePageQuery orderDesc(string column);

    /**
     * Executes the query and returns the {@link TablePage}.
     */
    TablePage listPage(int firstResult, int maxResults);
}
