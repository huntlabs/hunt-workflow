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

module flow.job.service.impl.persistence.entity.data.JobDataManager;

import hunt.collection.List;

import flow.common.persistence.entity.data.DataManager;
import flow.job.service.api.Job;
import flow.job.service.impl.JobQueryImpl;
import flow.job.service.impl.persistence.entity.JobEntity;
import flow.job.service.impl.persistence.entity.data.JobInfoDataManager;
/**
 * @author Joram Barrez
 */
interface JobDataManager : DataManager!JobEntity, JobInfoDataManager!JobEntity {

    List!Job findJobsByQueryCriteria(JobQueryImpl jobQuery);

    long findJobCountByQueryCriteria(JobQueryImpl jobQuery);

    void deleteJobsByExecutionId(string executionId);

}
