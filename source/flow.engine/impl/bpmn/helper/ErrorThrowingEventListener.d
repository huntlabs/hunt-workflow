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


import flow.common.api.FlowableException;
import flow.common.api.deleg.event.FlowableEngineEvent;
import flow.common.api.deleg.event.FlowableEvent;
import flow.common.api.deleg.event.FlowableEventListener;
import flow.common.context.Context;
import flow.common.interceptor.CommandContext;
import flow.engine.compatibility.Flowable5CompatibilityHandler;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.impl.util.Flowable5Util;

/**
 * An {@link FlowableEventListener} that throws a error event when an event is dispatched to it.
 * 
 * @author Frederik Heremans
 * 
 */
class ErrorThrowingEventListener extends BaseDelegateEventListener {

    protected string errorCode;

    @Override
    public void onEvent(FlowableEvent event) {
        if (isValidEvent(event) && event instanceof FlowableEngineEvent) {

            FlowableEngineEvent engineEvent = (FlowableEngineEvent) event;
            CommandContext commandContext = Context.getCommandContext();

            if (engineEvent.getProcessDefinitionId() !is null &&
                    Flowable5Util.isFlowable5ProcessDefinitionId(commandContext, engineEvent.getProcessDefinitionId())) {

                Flowable5CompatibilityHandler compatibilityHandler = Flowable5Util.getFlowable5CompatibilityHandler();
                compatibilityHandler.throwErrorEvent(event);
                return;
            }

            ExecutionEntity execution = null;

            if (engineEvent.getExecutionId() !is null) {
                // Get the execution based on the event's execution ID instead
                execution = CommandContextUtil.getExecutionEntityManager().findById(engineEvent.getExecutionId());
            }

            if (execution is null) {
                throw new FlowableException("No execution context active and event is not related to an execution. No compensation event can be thrown.");
            }

            try {
                ErrorPropagation.propagateError(errorCode, execution);
            } catch (Exception e) {
                throw new FlowableException("Error while propagating error-event", e);
            }
        }
    }

    public void setErrorCode(string errorCode) {
        this.errorCode = errorCode;
    }

    @Override
    public bool isFailOnException() {
        return true;
    }
}
