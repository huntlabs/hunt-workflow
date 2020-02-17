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


import org.flowable.bpmn.model.UserTask;

class AlfrescoUserTask extends UserTask {

    public static final string ALFRESCO_SCRIPT_TASK_LISTENER = "org.alfresco.repo.workflow.activiti.tasklistener.ScriptTaskListener";

    protected string runAs;
    protected string scriptProcessor;

    public string getRunAs() {
        return runAs;
    }

    public void setRunAs(string runAs) {
        this.runAs = runAs;
    }

    public string getScriptProcessor() {
        return scriptProcessor;
    }

    public void setScriptProcessor(string scriptProcessor) {
        this.scriptProcessor = scriptProcessor;
    }

    @Override
    public AlfrescoUserTask clone() {
        AlfrescoUserTask clone = new AlfrescoUserTask();
        clone.setValues(this);
        return clone;
    }

    public void setValues(AlfrescoUserTask otherElement) {
        super.setValues(otherElement);
        setRunAs(otherElement.getRunAs());
        setScriptProcessor(otherElement.getScriptProcessor());
    }
}
