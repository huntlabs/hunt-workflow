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


//import hunt.collection;
//
//import flow.common.persistence.entity.Entity;
//
///**
// * Interface to express a condition whether or not a cached entity should be used in the return result of a query.
// *
// * @author Joram Barrez
// */
//interface CachedEntityMatcher<EntityImpl extends Entity> {
//
//    /**
//     * Returns true if an entity from the cache should be retained (i.e. used as return result for a query).
//     *
//     * Most implementations of this interface probably don't need this method, and should extend the simpler {@link CachedEntityMatcherAdapter}, which hides this method.
//     *
//     * Note that the databaseEntities collection can be null, in case only the cache is checked.
//     */
//    bool isRetained(Collection<EntityImpl> databaseEntities, Collection<CachedEntity> cachedEntities, EntityImpl entity, Object param);
//
//}
