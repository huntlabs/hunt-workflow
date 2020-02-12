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


import java.io.Serializable;

import org.flowable.bpmn.model.BpmnModel;
import flow.common.api.FlowableIllegalArgumentException;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.engine.impl.util.ProcessDefinitionUtil;

/**
 * @author Joram Barrez
 */
class GetBpmnModelCmd implements Command<BpmnModel>, Serializable {

    private static final long serialVersionUID = 8167762371289445046L;

    protected string processDefinitionId;

    public GetBpmnModelCmd(string processDefinitionId) {
        this.processDefinitionId = processDefinitionId;
    }

    @Override
    public BpmnModel execute(CommandContext commandContext) {
        if (processDefinitionId == null) {
            throw new FlowableIllegalArgumentException("processDefinitionId is null");
        }

        return ProcessDefinitionUtil.getBpmnModel(processDefinitionId);
    }
}