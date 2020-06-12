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
module flow.engine.impl.cmd.GetEventLogEntriesCmd;

import hunt.collection.List;

import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.engine.event.EventLogEntry;
import flow.engine.impl.util.CommandContextUtil;

/**
 * @author Joram Barrez
 */
class GetEventLogEntriesCmd : Command!(List!EventLogEntry) {

    protected string processInstanceId;
    protected long startLogNr;
    protected long pageSize;

    this() {

    }

    this(string processInstanceId) {
        this.processInstanceId = processInstanceId;
    }

    this(long startLogNr, long pageSize) {
        this.startLogNr = startLogNr;
        this.pageSize = pageSize;
    }

    public List!EventLogEntry execute(CommandContext commandContext) {
        if (processInstanceId !is null && processInstanceId.length != 0) {
            return CommandContextUtil.getEventLogEntryEntityManager(commandContext).findEventLogEntriesByProcessInstanceId(processInstanceId);

        } else if (startLogNr != 0) {
            return CommandContextUtil.getEventLogEntryEntityManager(commandContext).findEventLogEntries(startLogNr, pageSize !is null ? pageSize : -1);

        } else {
            return CommandContextUtil.getEventLogEntryEntityManager(commandContext).findAllEventLogEntries();
        }
    }

}
