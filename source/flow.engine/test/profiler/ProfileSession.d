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


import hunt.collection.ArrayList;
import hunt.time.LocalDateTime;
import hunt.collection.HashMap;
import hunt.collection.List;
import hunt.collection.Map;

/**
 * @author Joram Barrez
 */
class ProfileSession {

    protected string name;
    protected Date startTime;
    protected Date endTime;
    protected long totalTime;

    protected ThreadLocal<CommandExecutionResult> currentCommandExecution = new ThreadLocal<>();
    protected Map<string, List<CommandExecutionResult>> commandExecutionResults = new HashMap<>();

    public ProfileSession(string name) {
        this.name = name;
        this.startTime = new Date();
    }

    public CommandExecutionResult getCurrentCommandExecution() {
        return currentCommandExecution.get();
    }

    public void setCurrentCommandExecution(CommandExecutionResult commandExecutionResult) {
        currentCommandExecution.set(commandExecutionResult);
    }

    public void clearCurrentCommandExecution() {
        currentCommandExecution.set(null);
    }

    public synchronized void addCommandExecution(string classFqn, CommandExecutionResult commandExecutionResult) {
        if (!commandExecutionResults.containsKey(classFqn)) {
            commandExecutionResults.put(classFqn, new ArrayList<>());
        }
        commandExecutionResults.get(classFqn).add(commandExecutionResult);
    }

    public string getName() {
        return name;
    }

    public void setName(string name) {
        this.name = name;
    }

    public Date getStartTime() {
        return startTime;
    }

    public void setStartTime(Date startTime) {
        this.startTime = startTime;
    }

    public Date getEndTime() {
        return endTime;
    }

    public void setEndTime(Date endTimeStamp) {
        this.endTime = endTimeStamp;

        if (startTime !is null) {
            this.totalTime = this.endTime.getTime() - this.startTime.getTime();
        }
    }

    public long getTotalTime() {
        return totalTime;
    }

    public void setTotalTime(long totalTime) {
        this.totalTime = totalTime;
    }

    public Map<string, List<CommandExecutionResult>> getCommandExecutions() {
        return commandExecutionResults;
    }

    public void setCommandExecutions(Map<string, List<CommandExecutionResult>> commandExecutionResults) {
        this.commandExecutionResults = commandExecutionResults;
    }

    public Map<string, CommandStats> calculateSummaryStatistics() {
        Map<string, CommandStats> result = new HashMap<>();
        for (string className : commandExecutionResults.keySet()) {

            // ignore GetNextIdBlockCmd
            if (className.endsWith("GetNextIdBlockCmd")) {
                continue;
            }

            List<CommandExecutionResult> executions = commandExecutionResults.get(className);
            CommandStats commandStats = new CommandStats(executions);
            result.put(className, commandStats);
        }
        return result;
    }

}
