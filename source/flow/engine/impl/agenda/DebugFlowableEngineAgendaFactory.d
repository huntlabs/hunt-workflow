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
module flow.engine.impl.agenda.DebugFlowableEngineAgendaFactory;

import flow.common.interceptor.CommandContext;
import flow.engine.FlowableEngineAgenda;
import flow.engine.FlowableEngineAgendaFactory;
import flow.engine.runtime.ProcessDebugger;
import flow.engine.impl.agenda.DebugFlowableEngineAgenda;

class DebugFlowableEngineAgendaFactory : FlowableEngineAgendaFactory {

    protected ProcessDebugger debugger;

    public void setDebugger(ProcessDebugger debugger) {
        this.debugger = debugger;
    }

    public FlowableEngineAgenda createAgenda(CommandContext commandContext) {
        return new DebugFlowableEngineAgenda(commandContext, debugger);
    }
}
