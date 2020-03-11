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

import org.apache.commons.lang3.StringUtils;
import flow.bpmn.model.BpmnModel;
import flow.bpmn.model.ExtensionElement;
import flow.bpmn.model.Process;
import flow.common.api.FlowableIllegalArgumentException;
import flow.common.history.HistoryLevel;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.impl.util.ProcessDefinitionUtil;
import flow.engine.repository.ProcessDefinition;

/**
 * @author Tijs Rademakers
 */
class GetProcessDefinitionHistoryLevelModelCmd implements Command<HistoryLevel>, Serializable {

    private static final long serialVersionUID = 1L;

    protected string processDefinitionId;

    public GetProcessDefinitionHistoryLevelModelCmd(string processDefinitionId) {
        this.processDefinitionId = processDefinitionId;
    }

    @Override
    public HistoryLevel execute(CommandContext commandContext) {
        if (processDefinitionId is null) {
            throw new FlowableIllegalArgumentException("processDefinitionId is null");
        }

        HistoryLevel historyLevel = null;

        ProcessDefinition processDefinition = CommandContextUtil.getProcessDefinitionEntityManager(commandContext).findById(processDefinitionId);

        BpmnModel bpmnModel = ProcessDefinitionUtil.getBpmnModel(processDefinitionId);

        Process process = bpmnModel.getProcessById(processDefinition.getKey());
        if (process.getExtensionElements().containsKey("historyLevel")) {
            ExtensionElement historyLevelElement = process.getExtensionElements().get("historyLevel").iterator().next();
            string historyLevelValue = historyLevelElement.getElementText();
            if (StringUtils.isNotEmpty(historyLevelValue)) {
                try {
                    historyLevel = HistoryLevel.getHistoryLevelForKey(historyLevelValue);

                } catch (Exception e) {
                }
            }
        }

        if (historyLevel is null) {
            historyLevel = CommandContextUtil.getProcessEngineConfiguration(commandContext).getHistoryLevel();
        }

        return historyLevel;
    }
}
