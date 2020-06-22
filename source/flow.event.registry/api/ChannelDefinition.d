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
module flow.event.registry.api.ChannelDefinition;

//import hunt.time.LocalDateTime;
import hunt.time.LocalDateTime;

alias Date =LocalDateTime;
/**
 * An object structure representing a channel definition
 *
 * @author Tijs Rademakers
 * @author Joram Barez
 */
interface ChannelDefinition {

    /** unique identifier */
    string getId();

    /** category name of the channel definition */
    string getCategory();

    /** label used for display purposes */
    string getName();

    /** unique name for all versions this channel definition */
    string getKey();

    /** version of this channel definition */
    int getVersion();

    /** description of this channel definition **/
    string getDescription();

    /** name of {@link EventRepositoryService#getResourceAsStream(string, string) the resource} of this channel definition. */
    string getResourceName();

    /** The deployment in which this channel definition is contained. */
    string getDeploymentId();

    /** create time for this channel definition */
    Date getCreateTime();

    /** The tenant identifier of this channel definition */
    string getTenantId();

}
