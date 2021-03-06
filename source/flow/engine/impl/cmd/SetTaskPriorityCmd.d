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
module flow.engine.impl.cmd.SetTaskPriorityCmd;

import flow.common.interceptor.CommandContext;
import flow.engine.compatibility.Flowable5CompatibilityHandler;
import flow.engine.impl.util.CommandContextUtil;
//import flow.engine.impl.util.Flowable5Util;
import flow.task.service.impl.persistence.entity.TaskEntity;
import flow.engine.impl.cmd.NeedsActiveTaskCmd;
import hunt.Object;
/**
 * @author Joram Barrez
 */
class SetTaskPriorityCmd : NeedsActiveTaskCmd!Void {


    protected int priority;

    this(string taskId, int priority) {
        super(taskId);
        this.priority = priority;
    }

    override
    protected Void execute(CommandContext commandContext, TaskEntity task) {
        //if (Flowable5Util.isFlowable5ProcessDefinitionId(commandContext, task.getProcessDefinitionId())) {
        //    Flowable5CompatibilityHandler compatibilityHandler = Flowable5Util.getFlowable5CompatibilityHandler();
        //    compatibilityHandler.setTaskPriority(taskId, priority);
        //    return null;
        //}

        task.setPriority(priority);
        CommandContextUtil.getActivityInstanceEntityManager(commandContext)
            .recordTaskInfoChange(task, commandContext.getCurrentEngineConfiguration().getClock().getCurrentTime());
        CommandContextUtil.getTaskService(commandContext).updateTask(task, true);
        return null;
    }

}
