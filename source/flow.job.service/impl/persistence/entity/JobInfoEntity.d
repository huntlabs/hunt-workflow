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
module flow.job.service.impl.persistence.entity.JobInfoEntity;

import hunt.time.LocalDateTime;

import flow.common.db.HasRevision;
import flow.common.persistence.entity.Entity;
import flow.job.service.api.JobInfo;
import  flow.job.service.impl.persistence.entity.AbstractJobEntity;

alias Date = LocalDateTime;

interface JobInfoEntity : JobInfo, AbstractJobEntity, Entity, HasRevision {

    string getLockOwner();

    void setLockOwner(string claimedBy);

    Date getLockExpirationTime();

    void setLockExpirationTime(Date claimedUntil);

}
