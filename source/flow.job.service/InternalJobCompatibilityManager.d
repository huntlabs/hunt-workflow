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

module flow.job.service.InternalJobCompatibilityManager;

import flow.job.service.api.Job;
import flow.job.service.impl.persistence.entity.AbstractRuntimeJobEntity;

/**
 * @author Tijs Rademakers
 * @author Joram Barrez
 */
interface InternalJobCompatibilityManager {

    bool isFlowable5Job(Job job);

    void executeV5Job(Job job);

    void executeV5JobWithLockAndRetry(Job job);

    void deleteV5Job(string jobId);

    void handleFailedV5Job(AbstractRuntimeJobEntity job, Throwable exception);

}
