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


import flow.engine.deleg.DelegateExecution;
import flow.engine.impl.bpmn.helper.ErrorPropagation;

/**
 * @author Joram Barrez
 * @author Tijs Rademakers
 */
class ErrorEndEventActivityBehavior extends FlowNodeActivityBehavior {

    private static final long serialVersionUID = 1L;

    protected string errorCode;

    public ErrorEndEventActivityBehavior(string errorCode) {
        this.errorCode = errorCode;
    }

    @Override
    public void execute(DelegateExecution execution) {
        ErrorPropagation.propagateError(errorCode, execution);
    }

    public string getErrorCode() {
        return errorCode;
    }

    public void setErrorCode(string errorCode) {
        this.errorCode = errorCode;
    }

}
