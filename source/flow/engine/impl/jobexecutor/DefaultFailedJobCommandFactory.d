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
module flow.engine.impl.jobexecutor.DefaultFailedJobCommandFactory;

import flow.common.interceptor.Command;
import flow.engine.impl.cmd.JobRetryCmd;
import flow.job.service.impl.asyncexecutor.FailedJobCommandFactory;

/**
 * @author Saeid Mirzaei
 */
class DefaultFailedJobCommandFactory : FailedJobCommandFactory {

    public Command!Object getCommand(string jobId, Throwable exception) {
        return new JobRetryCmd(jobId, exception);
    }

}
