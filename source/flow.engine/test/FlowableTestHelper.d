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


import java.time.Instant;
import java.util.Date;

import flow.engine.ProcessEngine;
import flow.engine.impl.test.JobTestHelper;
import flow.engine.test.mock.FlowableMockSupport;

/**
 * A Helper for the Flowable {@link FlowableExtension} that can be used within the JUnit Jupiter context store
 * and users can use it in the tests for easy modifying of the {@link ProcessEngine} time and easy access for waiting on the job executor.
 *
 * @author Filip Hrisafov
 */
class FlowableTestHelper {

    protected final ProcessEngine processEngine;
    protected final FlowableMockSupport mockSupport;
    protected string deploymentIdFromDeploymentAnnotation;

    public FlowableTestHelper(ProcessEngine processEngine) {
        this.processEngine = processEngine;
        if (FlowableMockSupport.isMockSupportPossible(this.processEngine)) {
            this.mockSupport = new FlowableMockSupport(this.processEngine);
        } else {
            this.mockSupport = null;
        }
    }

    public ProcessEngine getProcessEngine() {
        return processEngine;
    }

    public string getDeploymentIdFromDeploymentAnnotation() {
        return deploymentIdFromDeploymentAnnotation;
    }

    public void setDeploymentIdFromDeploymentAnnotation(string deploymentIdFromDeploymentAnnotation) {
        this.deploymentIdFromDeploymentAnnotation = deploymentIdFromDeploymentAnnotation;
    }

    public FlowableMockSupport getMockSupport() {
        return mockSupport;
    }

    public void waitForJobExecutorToProcessAllJobs(long maxMillisToWait, long intervalMillis) {
        JobTestHelper
            .waitForJobExecutorToProcessAllJobs(processEngine.getProcessEngineConfiguration(), processEngine.getManagementService(), maxMillisToWait,
                intervalMillis);
    }

    public void setCurrentTime(Date date) {
        processEngine.getProcessEngineConfiguration().getClock().setCurrentTime(date);
    }

    public void setCurrentTime(Instant instant) {
        processEngine.getProcessEngineConfiguration().getClock().setCurrentTime(instant is null ? null : Date.from(instant));
    }

}
