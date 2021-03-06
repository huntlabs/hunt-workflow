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
module flow.job.service.impl.persistence.entity.AbstractJobServiceEntity;

import flow.common.persistence.entity.AbstractEntity;
import flow.job.service.impl.persistence.entity.JobServiceEntityConstants;
import hunt.Exceptions;
import flow.common.persistence.entity.Entity;

class AbstractJobServiceEntity : AbstractEntity {

    public string getIdPrefix() {
        return JobServiceEntityConstants.JOB_SERVICE_ID_PREFIX;
    }

    public string getId() {
        return "";
    }


    public void setId(string id) {
       // this.id = id;
    }

    Object getPersistentState()
    {
        implementationMissing(false);
        return null;
    }

    int opCmp(Entity o)
    {
        return 1;
    }
}
