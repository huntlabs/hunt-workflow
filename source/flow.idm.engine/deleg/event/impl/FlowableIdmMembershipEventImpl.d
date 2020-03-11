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
module flow.idm.engine.deleg.event.impl.FlowableIdmMembershipEventImpl;

import flow.idm.api.event.FlowableIdmEventType;
import flow.idm.api.event.FlowableIdmMembershipEvent;
import flow.idm.engine.deleg.event.impl.FlowableIdmEventImpl;

/**
 * Implementation of {@link FlowableIdmMembershipEvent}.
 *
 * @author Frederik Heremans
 */
class FlowableIdmMembershipEventImpl : FlowableIdmEventImpl , FlowableIdmMembershipEvent {

    protected string userId;
    protected string groupId;

    this(FlowableIdmEventType type) {
        super(type);
    }

    public void setUserId(string userId) {
        this.userId = userId;
    }

    public string getUserId() {
        return userId;
    }

    public void setGroupId(string groupId) {
        this.groupId = groupId;
    }

    public string getGroupId() {
        return groupId;
    }
}
