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

module flow.common.api.query.Query;



import hunt.collection.List;
import flow.common.api.query.QueryProperty;
//import hunt.collection.List;

/**
 * Describes basic methods for querying.
 *
 * @author Frederik Heremans
 */

//interface Query<T extends Query<?, ?>, U extends Object>
enum NullHandlingOnOrder {
  NULLS_FIRST, NULLS_LAST
}

interface Query(T,U) {



    /**
     * Order the results ascending on the given property as defined in this class (needs to come after a call to one of the orderByXxxx methods).
     */
    T asc();

    /**
     * Order the results descending on the given property as defined in this class (needs to come after a call to one of the orderByXxxx methods).
     */
    T desc();

    T orderBy(QueryProperty property);

    T orderBy(QueryProperty property, NullHandlingOnOrder nullHandlingOnOrder);

    /**
     * Executes the query and returns the number of results
     */
    long count();

    /**
     * Executes the query and returns the resulting entity or null if no entity matches the query criteria.
     *
     * @throws flow.common.api.FlowableException when the query results in more than one entities.
     */
    U singleResult();

    /**
     * Executes the query and get a list of entities as the result.
     */
    List!U list();

    /**
     * Executes the query and get a list of entities as the result.
     */
    List!U listPage(int firstResult, int maxResults);
}