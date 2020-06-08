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
module flow.engine.impl.interceptor.LoggingExecutionTreeCommandInvoker;

import flow.engine.impl.agenda.AbstractOperation;
import flow.engine.impl.interceptor.CommandInvoker;
import hunt.util.Runnable;
import hunt.logging;
/**
 * @author Joram Barrez
 */
class LoggingExecutionTreeCommandInvoker : CommandInvoker {

    override
    public void executeOperation(Runnable runnable) {
        if (cast(AbstractOperation)runnable !is null) {
            AbstractOperation operation = cast(AbstractOperation) runnable;

            if (operation.getExecution() !is null) {
                logInfo("Execution tree while executing operation {}: %s", typeid(operation).toString);
                //LOGGER.info("{}", System.lineSeparator() + ExecutionTreeUtil.buildExecutionTree(operation.getExecution()));
            }

        }
        super.executeOperation(runnable);
    }

}
