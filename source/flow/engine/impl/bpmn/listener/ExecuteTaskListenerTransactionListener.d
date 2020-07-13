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
module flow.engine.impl.bpmn.listener.ExecuteTaskListenerTransactionListener;

import flow.common.cfg.TransactionListener;
import flow.common.cfg.TransactionPropagation;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandConfig;
import flow.common.interceptor.CommandContext;
import flow.common.interceptor.CommandExecutor;
import flow.engine.deleg.ExecutionListener;
import flow.engine.deleg.TransactionDependentTaskListener;
import flow.engine.impl.bpmn.listener.TransactionDependentTaskListenerExecutionScope;
import hunt.Exceptions;
import hunt.Object;
/**
 * A {@link TransactionListener} that invokes an {@link ExecutionListener}.
 *
 * @author Joram Barrez
 */
class ExecuteTaskListenerTransactionListener : TransactionListener {

    protected TransactionDependentTaskListener listener;
    protected TransactionDependentTaskListenerExecutionScope scop;
    protected CommandExecutor commandExecutor;

    this(TransactionDependentTaskListener listener,
            TransactionDependentTaskListenerExecutionScope scop, CommandExecutor commandExecutor) {
        this.listener = listener;
        this.scop = scop;
        this.commandExecutor = commandExecutor;
    }

    public void execute(CommandContext commandContext) {
        CommandConfig commandConfig = new CommandConfig(false, TransactionPropagation.REQUIRES_NEW);
        commandExecutor.execute(commandConfig, new class Command!Void {
            public Void execute(CommandContext commandContext) {
                listener.notify(scop.getProcessInstanceId(), scop.getExecutionId(), scop.getTask(),
                        scop.getExecutionVariables(), scop.getCustomPropertiesMap());
                return null;
            }
        });
    }

}
