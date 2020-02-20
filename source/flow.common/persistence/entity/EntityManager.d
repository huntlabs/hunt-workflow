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


/**
 * @author Joram Barrez
 */
interface EntityManager<EntityImpl extends Entity> {

    EntityImpl create();

    EntityImpl findById(string entityId);

    void insert(EntityImpl entity);

    void insert(EntityImpl entity, bool fireCreateEvent);

    EntityImpl update(EntityImpl entity);

    EntityImpl update(EntityImpl entity, bool fireUpdateEvent);

    void delete(string id);

    void delete(EntityImpl entity);

    void delete(EntityImpl entity, bool fireDeleteEvent);

}