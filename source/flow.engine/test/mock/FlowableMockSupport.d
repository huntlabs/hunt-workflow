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


import java.util.Collections;
import java.util.List;

import flow.engine.ProcessEngine;
import flow.engine.impl.ProcessEngineImpl;
import flow.engine.impl.bpmn.parser.factory.ActivityBehaviorFactory;
import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
import flow.engine.impl.test.NoOpServiceTask;
import flow.engine.test.TestActivityBehaviorFactory;

/**
 * @author Joram Barrez
 */
class FlowableMockSupport {

    protected TestActivityBehaviorFactory testActivityBehaviorFactory;

    public FlowableMockSupport(TestActivityBehaviorFactory testActivityBehaviorFactory) {
        this.testActivityBehaviorFactory = testActivityBehaviorFactory;
    }

    public FlowableMockSupport(ProcessEngine processEngine) {
        ProcessEngineConfigurationImpl processEngineConfiguration = ((ProcessEngineImpl) processEngine).getProcessEngineConfiguration();
        ActivityBehaviorFactory existingActivityBehaviorFactory = processEngineConfiguration.getActivityBehaviorFactory();
        this.testActivityBehaviorFactory = new TestActivityBehaviorFactory(existingActivityBehaviorFactory);

        processEngineConfiguration.setActivityBehaviorFactory(testActivityBehaviorFactory);
        processEngineConfiguration.getBpmnParser().setActivityBehaviorFactory(testActivityBehaviorFactory);
    }

    public static boolean isMockSupportPossible(ProcessEngine processEngine) {
        return processEngine instanceof ProcessEngineImpl;
    }

    public void mockServiceTaskWithClassDelegate(string originalClassFqn, Class<?> mockedClass) {
        testActivityBehaviorFactory.addClassDelegateMock(originalClassFqn, mockedClass);
    }

    public void mockServiceTaskWithClassDelegate(string originalClassFqn, string mockedClassFqn) {
        testActivityBehaviorFactory.addClassDelegateMock(originalClassFqn, mockedClassFqn);
    }

    public void mockServiceTaskByIdWithClassDelegate(string taskId, Class<?> mockedClass) {
        testActivityBehaviorFactory.addClassDelegateMockByTaskId(taskId, mockedClass);
    }

    public void mockServiceTaskByIdWithClassDelegate(string taskId, string mockedClassFqn) {
        testActivityBehaviorFactory.addClassDelegateMockByTaskId(taskId, mockedClassFqn);
    }

    public void setAllServiceTasksNoOp() {
        testActivityBehaviorFactory.setAllServiceTasksNoOp();
    }

    public void addNoOpServiceTaskById(string id) {
        testActivityBehaviorFactory.addNoOpServiceTaskById(id);
    }

    public void addNoOpServiceTaskByClassName(string className) {
        testActivityBehaviorFactory.addNoOpServiceTaskByClassName(className);
    }

    public int getNrOfNoOpServiceTaskExecutions() {
        return NoOpServiceTask.CALL_COUNT.get();
    }

    public List<string> getExecutedNoOpServiceTaskDelegateClassNames() {
        return Collections.unmodifiableList(NoOpServiceTask.NAMES);
    }

    public void reset() {
        testActivityBehaviorFactory.reset();
    }

}
