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

module flow.engine.impl.db.DbIdGenerator;

import flow.common.cfg.IdGenerator;
import flow.common.db.IdBlock;
import flow.common.interceptor.CommandConfig;
import flow.common.interceptor.CommandExecutor;
import flow.engine.impl.cmd.GetNextIdBlockCmd;
import std.conv : to;
import hunt.logging;
/**
 * @author Tom Baeyens
 */
class DbIdGenerator : IdGenerator {

    protected int idBlockSize;
    protected  long nextId;
    protected  long lastId = -1;

    protected CommandExecutor commandExecutor;
    protected CommandConfig commandConfig;

    public  string getNextId() {
      synchronized (this){
        if (lastId < nextId) {
          getNewBlock();
        }
        long _nextId = nextId++;
        return to!string(_nextId);
      }
    }

    protected  void getNewBlock() {
        IdBlock idBlock = cast(IdBlock)(commandExecutor.execute(commandConfig, new GetNextIdBlockCmd(idBlockSize)));
        if (idBlock is null)
        {
            logError("IdBlock is null .....");
        }
        this.nextId = idBlock.getNextId();
        this.lastId = idBlock.getLastId();
    }

    public int getIdBlockSize() {
        return idBlockSize;
    }

    public void setIdBlockSize(int idBlockSize) {
        this.idBlockSize = idBlockSize;
    }

    public CommandExecutor getCommandExecutor() {
        return commandExecutor;
    }

    public void setCommandExecutor(CommandExecutor commandExecutor) {
        this.commandExecutor = commandExecutor;
    }

    public CommandConfig getCommandConfig() {
        return commandConfig;
    }

    public void setCommandConfig(CommandConfig commandConfig) {
        this.commandConfig = commandConfig;
    }
}
