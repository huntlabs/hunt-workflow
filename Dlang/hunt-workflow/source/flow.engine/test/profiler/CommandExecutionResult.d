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


import java.util.HashMap;
import java.util.Map;

/**
 * @author Joram Barrez
 */
class CommandExecutionResult {

    protected string commandFqn;
    protected long totalTimeInMs;
    protected long databaseTimeInMs;

    protected Map<string, Long> dbSelects = new HashMap<>();
    protected Map<string, Long> dbInserts = new HashMap<>();
    protected Map<string, Long> dbUpdates = new HashMap<>();
    protected Map<string, Long> dbDeletes = new HashMap<>();

    public string getCommandFqn() {
        return commandFqn;
    }

    public void setCommandFqn(string commandFqn) {
        this.commandFqn = commandFqn;
    }

    public long getTotalTimeInMs() {
        return totalTimeInMs;
    }

    public void setTotalTimeInMs(long totalTimeInMs) {
        this.totalTimeInMs = totalTimeInMs;
    }

    public long getDatabaseTimeInMs() {
        return databaseTimeInMs;
    }

    public void setDatabaseTimeInMs(long databaseTimeInMs) {
        this.databaseTimeInMs = databaseTimeInMs;
    }

    public void addDatabaseTime(long time) {
        this.databaseTimeInMs += time;
    }

    public Map<string, Long> getDbSelects() {
        return dbSelects;
    }

    public void addDbSelect(string select) {
        if (!dbSelects.containsKey(select)) {
            dbSelects.put(select, 0L);
        }
        Long oldValue = dbSelects.get(select);
        dbSelects.put(select, oldValue + 1);
    }

    public void setDbSelects(Map<string, Long> dbSelects) {
        this.dbSelects = dbSelects;
    }

    public Map<string, Long> getDbInserts() {
        return dbInserts;
    }

    public void addDbInsert(string insert) {
        if (!dbInserts.containsKey(insert)) {
            dbInserts.put(insert, 0L);
        }
        Long oldValue = dbInserts.get(insert);
        dbInserts.put(insert, oldValue + 1);
    }

    public void setDbInserts(Map<string, Long> dbInserts) {
        this.dbInserts = dbInserts;
    }

    public Map<string, Long> getDbUpdates() {
        return dbUpdates;
    }

    public void addDbUpdate(string update) {
        if (!dbUpdates.containsKey(update)) {
            dbUpdates.put(update, 0L);
        }
        Long oldValue = dbUpdates.get(update);
        dbUpdates.put(update, oldValue + 1);
    }

    public void setDbUpdates(Map<string, Long> dbUpdates) {
        this.dbUpdates = dbUpdates;
    }

    public Map<string, Long> getDbDeletes() {
        return dbDeletes;
    }

    public void addDbDelete(string delete) {
        if (!dbDeletes.containsKey(delete)) {
            dbDeletes.put(delete, 0L);
        }
        Long oldValue = dbDeletes.get(delete);
        dbDeletes.put(delete, oldValue + 1);
    }

    public void setDbDeletes(Map<string, Long> dbDeletes) {
        this.dbDeletes = dbDeletes;
    }
}
