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
module flow.engine.DefaultCandidateManager;

import hunt.collection.ArrayList;
import hunt.collection.List;

import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
import flow.engine.impl.persistence.AbstractManager;
import flow.idm.api.Group;
import flow.engine.CandidateManager;
import flow.engine.IdentityService;

class DefaultCandidateManager : AbstractManager , CandidateManager {

    this(ProcessEngineConfigurationImpl processEngineConfiguration) {
        super(processEngineConfiguration);
    }

    public List!string getGroupsForCandidateUser(string candidateUser) {
        IdentityService identityService = getProcessEngineConfiguration().getIdentityService();
        List!Group groups = identityService.createGroupQuery().groupMember(candidateUser).list();
        List!string groupIds = new ArrayList!string();
        foreach (Group group ; groups) {
            groupIds.add(group.getId());
        }
        return groupIds;
    }
}
