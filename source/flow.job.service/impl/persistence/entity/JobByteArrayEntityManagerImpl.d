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

module flow.job.service.impl.persistence.entity.JobByteArrayEntityManagerImpl;

import hunt.collection.List;

import flow.job.service.JobServiceConfiguration;
import flow.job.service.impl.persistence.entity.data.JobByteArrayDataManager;
import flow.job.service.impl.persistence.entity.AbstractJobServiceEngineEntityManager;
import flow.job.service.impl.persistence.entity.JobByteArrayEntity;
import flow.job.service.impl.persistence.entity.JobByteArrayEntityManager;

/**
 * @author Joram Barrez
 * @author Marcus Klimstra (CGI)
 */
class JobByteArrayEntityManagerImpl
    : AbstractJobServiceEngineEntityManager!(JobByteArrayEntity, JobByteArrayDataManager)
    , JobByteArrayEntityManager {

    this(JobServiceConfiguration jobServiceConfiguration, JobByteArrayDataManager byteArrayDataManager) {
        super(jobServiceConfiguration, byteArrayDataManager);
    }


    public List!JobByteArrayEntity findAll() {
        return dataManager.findAll();
    }


    public void deleteByteArrayById(string byteArrayEntityId) {
        dataManager.deleteByteArrayNoRevisionCheck(byteArrayEntityId);
    }

}
