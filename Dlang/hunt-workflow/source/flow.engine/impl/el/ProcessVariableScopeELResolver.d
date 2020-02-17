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


import flow.common.api.variable.VariableContainer;
import flow.common.el.VariableContainerELResolver;
import flow.common.javax.el.ELContext;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.util.CommandContextUtil;
import org.flowable.task.service.impl.persistence.entity.TaskEntity;

/**
 * @author Joram Barrez
 */
class ProcessVariableScopeELResolver extends VariableContainerELResolver  {
    
    public ProcessVariableScopeELResolver(VariableContainer variableContainer) {
        super(variableContainer);
    }

    public static final string EXECUTION_KEY = "execution";
    public static final string TASK_KEY = "task";

    @Override
    public Object getValue(ELContext context, Object base, Object property) {
        if (base == null) {
            if ((EXECUTION_KEY.equals(property) && variableContainer instanceof ExecutionEntity) || (TASK_KEY.equals(property) && variableContainer instanceof TaskEntity)) {
                context.setPropertyResolved(true);
                return variableContainer;
                
            } else if (EXECUTION_KEY.equals(property) && variableContainer instanceof TaskEntity) {
                context.setPropertyResolved(true);
                string executionId = ((TaskEntity) variableContainer).getExecutionId();
                ExecutionEntity executionEntity = null;
                if (executionId != null) {
                    executionEntity = CommandContextUtil.getExecutionEntityManager().findById(executionId);
                }
                return executionEntity;
                
            } else {
                return super.getValue(context, base, property);
            }
        }
        return null;
    }

}
