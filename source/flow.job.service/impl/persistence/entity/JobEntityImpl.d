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
module flow.job.service.impl.persistence.entity.JobEntityImpl;

import hunt.time.LocalDateTime;
import hunt.collection.Map;
import flow.job.service.impl.persistence.entity.AbstractJobEntityImpl;
import flow.job.service.impl.persistence.entity.JobEntity;
import hunt.entity;
alias Date =LocalDateTime;

/**
 * Job entity.
 *
 * @author Joram Barrez
 * @author Tijs Rademakers
 */
@Table("ACT_RU_JOB")
class JobEntityImpl : AbstractJobEntityImpl , Model,JobEntity {

    mixin MakeModel;

    @PrimaryKey
    @Column("ID_")
    string id;

    @Column("LOCK_OWNER_")
    string lockOwner;

    @Column("LOCK_EXP_TIME_")
    int lockExpirationTime;

    override
    public Object getPersistentState() {
        //Map!(string, Object) persistentState = cast(Map!(string, Object)) super.getPersistentState();
        //persistentState.put("lockOwner", lockOwner);
        //persistentState.put("lockExpirationTime", lockExpirationTime);

        return this;
    }

    // getters and setters ////////////////////////////////////////////////////////


    public string getLockOwner() {
        return lockOwner;
    }


    public void setLockOwner(string claimedBy) {
        this.lockOwner = claimedBy;
    }


    public Date getLockExpirationTime() {
        return Date.ofEpochMilli(cast(long)lockExpirationTime);
    }


    public void setLockExpirationTime(Date claimedUntil) {
        this.lockExpirationTime = cast(int)(claimedUntil.toEpochMilli);
    }


    override
    public string toString() {
        return "JobEntity [id=" ~ id ~ "]";
    }

}
