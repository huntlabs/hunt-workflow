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
module flow.engine.impl.jobexecutor.AsyncCompleteCallActivityJobHandler;

import flow.common.interceptor.CommandContext;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.util.CommandContextUtil;
import flow.job.service.JobHandler;
import flow.job.service.impl.persistence.entity.JobEntity;
import flow.variable.service.api.deleg.VariableScope;

/**
 * A {@link JobHandler} implementation that asynchronously will end an execution asynchronously.
 *
 * Primary use case is handling a parallel multi-instance call activity where the child process
 * has an async step just before reaching the end event.
 * The async locking happens on the level of the child process instance, but the end event will
 * execute the completing/completed callbacks of the call activity, which are done in scope of
 * the parent process instance and can lead to optimistic locking exceptions.
 * By scheduling the job in context of the parent process instance, the correct lock will be used.
 *
 * @author Joram Barrez
 */
class AsyncCompleteCallActivityJobHandler : JobHandler {

    public static  string TYPE = "async-complete-call-actiivty";

    public string getType() {
        return TYPE;
    }

    public void execute(JobEntity job, string configuration, VariableScope variableScope, CommandContext commandContext) {  // the executionId of the job = the parent execution, which will be used for locking
        ExecutionEntity childProcessInstanceExecutionEntity = CommandContextUtil.getExecutionEntityManager(commandContext).findById(configuration); // the child process instance execution
        CommandContextUtil.getAgenda(commandContext).planEndExecutionOperationSynchronous(childProcessInstanceExecutionEntity);
    }

}
