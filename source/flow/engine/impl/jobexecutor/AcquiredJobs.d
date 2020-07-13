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
module flow.engine.impl.jobexecutor.AcquiredJobs;

import hunt.collection.ArrayList;
import hunt.collection.HashSet;
import hunt.collection.List;
import hunt.collection.Set;

/**
 * @author Tom Baeyens
 * @author Daniel Meyer
 */
class AcquiredJobs {

    protected List!(List!string) acquiredJobBatches  ;//= new ArrayList<>();
    protected Set!string acquiredJobs ;//= new HashSet<>();

    this()
    {
        acquiredJobBatches = new ArrayList!(List!string);
        acquiredJobs = new HashSet!string;
    }

    public List!(List!string) getJobIdBatches() {
        return acquiredJobBatches;
    }

    public void addJobIdBatch(List!string jobIds) {
        acquiredJobBatches.add(jobIds);
        acquiredJobs.addAll(jobIds);
    }

    public bool contains(string jobId) {
        return acquiredJobs.contains(jobId);
    }

    public int size() {
        return acquiredJobs.size();
    }

}
