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
module flow.engine.impl.cmd.TriggerCaseTaskCmd;

import hunt.collection.Map;

import flow.bpmn.model.CaseServiceTask;
import flow.bpmn.model.FlowElement;
import flow.common.api.FlowableException;
import flow.common.api.FlowableIllegalArgumentException;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.engine.impl.bpmn.behavior.CaseTaskActivityBehavior;
import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.util.CommandContextUtil;
import hunt.Object;

/**
 * @author Tijs Rademakers
 */
class TriggerCaseTaskCmd : Command!Void {

    protected string executionId;
    protected Map!(string, Object) variables;

    this(string executionId, Map!(string, Object) variables) {
        this.executionId = executionId;

        if (executionId is null) {
            throw new FlowableIllegalArgumentException("executionId is null");
        }

        this.variables = variables;
    }

    public Void execute(CommandContext commandContext) {
        ProcessEngineConfigurationImpl processEngineConfiguration = CommandContextUtil.getProcessEngineConfiguration(commandContext);
        ExecutionEntity execution = cast(ExecutionEntity) processEngineConfiguration.getExecutionEntityManager().findById(executionId);
        if (execution is null) {
            throw new FlowableException("No execution could be found for id " ~ executionId);
        }

        FlowElement flowElement = execution.getCurrentFlowElement();
        if (cast(CaseServiceTask)flowElement  is null) {
            throw new FlowableException("No execution could be found with a case service task for id " + executionId);
        }

        CaseServiceTask caseServiceTask = cast(CaseServiceTask) flowElement;

        CaseTaskActivityBehavior caseTaskActivityBehavior = cast(CaseTaskActivityBehavior) caseServiceTask.getBehavior();
        caseTaskActivityBehavior.triggerCaseTask(execution, variables);

        return null;
    }
}
