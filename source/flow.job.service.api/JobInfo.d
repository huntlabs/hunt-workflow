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
//          Copyright linse 2020.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)}

module flow.job.service.api.JobInfo;






/**
 * Interface for a job that can be directly executed (e.g an async job or a history job).
 */
interface JobInfo {

    static int MAX_EXCEPTION_MESSAGE_LENGTH = 255;

    /**
     * Returns the unique identifier for this job.
     */
    string getId();

    /**
     * Returns the number of retries this job has left. Whenever the jobexecutor fails to execute the job, this value is decremented.
     * When it hits zero, the job is supposed to be dead and not retried again (ie a manual retry is required then).
     */
    int getRetries();

    /**
     * Returns the message of the exception that occurred, the last time the job was executed. Returns null when no exception occurred.
     *
     * To get the full exception stacktrace, use ManagementService#getJobExceptionStacktrace(string)
     */
    string getExceptionMessage();

    /**
     * Get the tenant identifier for this job.
     */
    string getTenantId();

    /**
     * Get the job handler type.
     */
    string getJobHandlerType();

    /**
     * Get the job handler configuration.
     */
    string getJobHandlerConfiguration();

    /**
     * Get the custom values.
     */
    string getCustomValues();

}
