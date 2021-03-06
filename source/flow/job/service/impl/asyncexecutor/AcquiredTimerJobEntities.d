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
module flow.job.service.impl.asyncexecutor.AcquiredTimerJobEntities;

import hunt.collection;
import hunt.collection.HashMap;
import hunt.collection.Map;

import flow.job.service.impl.persistence.entity.TimerJobEntity;
import hunt.collection.ArrayList;
/**
 * @author Tijs Rademakers
 */
class AcquiredTimerJobEntities {

    protected Map!(string, TimerJobEntity) acquiredJobs ;//= new HashMap<>();

    this()
    {
      acquiredJobs = new HashMap!(string, TimerJobEntity);
    }

    public void addJob(TimerJobEntity job) {
        acquiredJobs.put(job.getId(), job);
    }

    public Collection!TimerJobEntity getJobs() {
        return new ArrayList!TimerJobEntity(acquiredJobs.values());
    }

    public bool contains(string jobId) {
        return acquiredJobs.containsKey(jobId);
    }

    public int size() {
        return acquiredJobs.size();
    }
}
