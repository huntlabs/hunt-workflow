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
module flow.job.service.impl.persistence.entity.TimerJobEntityImpl;

import hunt.time.LocalDateTime;
import hunt.collection.Map;
import flow.job.service.impl.persistence.entity.AbstractJobEntityImpl;

import flow.job.service.impl.persistence.entity.TimerJobEntity;

import hunt.entity;

alias Date = LocalDateTime;
/**
 * TimerJob entity, necessary for persistence.
 *
 * @author Tijs Rademakers
 */
@Table("ACT_RU_TIMER_JOB")
class TimerJobEntityImpl : AbstractJobEntityImpl , Model,TimerJobEntity {

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
        return this;

        //Map!(string, Object) persistentState = (Map!(string, Object)) super.getPersistentState();
        //persistentState.put("lockOwner", lockOwner);
        //persistentState.put("lockExpirationTime", lockExpirationTime);
        //
        //return persistentState;
    }

    // getters and setters ////////////////////////////////////////////////////////


    public string getLockOwner() {
        return lockOwner;
    }


    public void setLockOwner(string claimedBy) {
        this.lockOwner = claimedBy;
    }


    public Date getLockExpirationTime() {
        return lockExpirationTime;
    }


    public void setLockExpirationTime(Date claimedUntil) {
        this.lockExpirationTime = claimedUntil;
    }

    override
    public string toString() {
        return "TimerJobEntity [id=" ~ id ~ "]";
    }

}
