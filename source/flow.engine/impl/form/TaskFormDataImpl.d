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

module flow.engine.impl.form.TaskFormDataImpl;

import flow.engine.form.TaskFormData;
import flow.task.api.Task;
import flow.engine.impl.form.FormDataImpl;
/**
 * @author Tom Baeyens
 */
class TaskFormDataImpl : FormDataImpl , TaskFormData {


    protected Task task;

    // getters and setters
    // //////////////////////////////////////////////////////

    public Task getTask() {
        return task;
    }

    public void setTask(Task task) {
        this.task = task;
    }
}
