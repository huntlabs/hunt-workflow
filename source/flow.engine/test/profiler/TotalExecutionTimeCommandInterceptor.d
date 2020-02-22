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


import flow.common.interceptor.AbstractCommandInterceptor;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandConfig;

/**
 * @author Joram Barrez
 */
class TotalExecutionTimeCommandInterceptor extends AbstractCommandInterceptor {

    protected FlowableProfiler profiler;

    public TotalExecutionTimeCommandInterceptor() {
        this.profiler = FlowableProfiler.getInstance();
    }

    @Override
    public <T> T execute(CommandConfig config, Command<T> command) {
        ProfileSession currentProfileSession = profiler.getCurrentProfileSession();

        if (currentProfileSession !is null) {

            string className = command.getClass().getName();
            CommandExecutionResult commandExecutionResult = new CommandExecutionResult();
            currentProfileSession.setCurrentCommandExecution(commandExecutionResult);

            commandExecutionResult.setCommandFqn(className);

            long start = System.currentTimeMillis();
            T result = next.execute(config, command);
            long end = System.currentTimeMillis();
            long totalTime = end - start;
            commandExecutionResult.setTotalTimeInMs(totalTime);

            currentProfileSession.addCommandExecution(className, commandExecutionResult);
            currentProfileSession.clearCurrentCommandExecution();

            return result;

        } else {
            return next.execute(config, command);
        }

    }

}