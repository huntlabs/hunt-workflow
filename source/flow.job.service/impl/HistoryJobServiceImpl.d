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
module flow.job.service.impl.HistoryJobServiceImpl;

import hunt.collection.List;

import flow.job.service.api.HistoryJob;
import flow.job.service.HistoryJobService;
import flow.job.service.JobServiceConfiguration;
import flow.job.service.impl.persistence.entity.HistoryJobEntity;
import flow.job.service.impl.ServiceImpl;
import flow.job.service.impl.HistoryJobQueryImpl;
/**
 * @author Tijs Rademakers
 */
class HistoryJobServiceImpl : ServiceImpl , HistoryJobService {

    this(JobServiceConfiguration jobServiceConfiguration) {
        super(jobServiceConfiguration);
    }


    public List!HistoryJob findHistoryJobsByQueryCriteria(HistoryJobQueryImpl query) {
        return getHistoryJobEntityManager().findHistoryJobsByQueryCriteria(query);
    }


    public HistoryJobEntity createHistoryJob() {
        return getHistoryJobEntityManager().create();
    }


    public void scheduleHistoryJob(HistoryJobEntity historyJob) {
        getJobManager().scheduleHistoryJob(historyJob);
    }


    public void deleteHistoryJob(HistoryJobEntity historyJob) {
        getHistoryJobEntityManager().dele(historyJob);
    }
}
