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

module flow.common.api.query.NativeQuery;





import hunt.collection.List;

import flow.common.api.FlowableException;

/**
 * Describes basic methods for doing native queries
 *
 * @author Tijs Rademakers
 * @author Joram Barrez
 */
//interface NativeQuery<T extends NativeQuery<?, ?>, U extends Object>
interface NativeQuery(T,U) {

    /**
     * Hand in the SQL statement you want to execute. BEWARE: if you need a count you have to hand in a count() statement yourself, otherwise the result will be treated as lost of Flowable entities.
     *
     * If you need paging you have to insert the pagination code yourself. We skipped doing this for you as this is done really different on some databases (especially MS-SQL / DB2)
     */
    T sql(string selectClause);

    /**
     * Add parameter to be replaced in query for index, e.g. :param1, :myParam, ...
     */
    T parameter(string name, Object value);

    /** Executes the query and returns the number of results */
    long count();

    /**
     * Executes the query and returns the resulting entity or null if no entity matches the query criteria.
     *
     * @throws FlowableException
     *             when the query results in more than one entities.
     */
    U singleResult();

    /** Executes the query and get a list of entities as the result. */
    List!U list();

    /** Executes the query and get a list of entities as the result. */
    List!U listPage(int firstResult, int maxResults);
}
