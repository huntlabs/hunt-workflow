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

module flow.event.registry.api.EventDeployment;

import hunt.time.LocalDateTime;

alias Date = LocalDateTime;
/**
 * Represents a deployment that is already present in the event repository.
 *
 * A deployment is a container for resources such as event definitions, image, etc.
 *
 * @author Tijs Rademakers
 * @author Joram Barrez
 */
interface EventDeployment {

    string getId();

    string getName();

    Date getDeploymentTime();

    string getCategory();

    string getTenantId();

    string getParentDeploymentId();
}
