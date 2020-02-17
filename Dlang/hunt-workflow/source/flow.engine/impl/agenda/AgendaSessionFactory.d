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


import flow.common.interceptor.CommandContext;
import flow.common.interceptor.Session;
import flow.common.interceptor.SessionFactory;
import flow.engine.FlowableEngineAgenda;
import flow.engine.FlowableEngineAgendaFactory;

class AgendaSessionFactory implements SessionFactory {
    
    protected FlowableEngineAgendaFactory flowableEngineAgendaFactory;
    
    public AgendaSessionFactory(FlowableEngineAgendaFactory flowableEngineAgendaFactory) {
        this.flowableEngineAgendaFactory = flowableEngineAgendaFactory;
    }

    @Override
    class<?> getSessionType() {
        return FlowableEngineAgenda.class;
    }

    @Override
    public Session openSession(CommandContext commandContext) {
        return flowableEngineAgendaFactory.createAgenda(commandContext);
    }

}
