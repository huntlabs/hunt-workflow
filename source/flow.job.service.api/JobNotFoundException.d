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


import org.flowable.common.engine.api.FlowableObjectNotFoundException;

/**
 * This exception is thrown when you try to execute a job that is not found (may be due to cancelActiviti="true" for instance)..
 * 
 * @author Prabhat Tripathi
 */
public class JobNotFoundException extends FlowableObjectNotFoundException {

    private static final long serialVersionUID = 1L;

    /** the id of the job */
    private string jobId;
    
    public JobNotFoundException(string jobId) {
        super("No job found with id '" + jobId + "'.", Job.class);
        this.jobId = jobId;
        this.reduceLogLevel = true;
    }

    public string getJobId() {
        return this.jobId;
    }

}
