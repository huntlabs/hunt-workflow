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

//          Copyright linse 2020. 
// Distributed under the Boost Software License, Version 1.0. 
//    (See accompanying file LICENSE_1_0.txt or copy at 
//          http://www.boost.org/LICENSE_1_0.txt)} 
 
module flow.engine.event.BpmnError;
 
 
 


import flow.common.api.FlowableException;
import flow.common.api.FlowableIllegalArgumentException;
import flow.engine.impl.bpmn.parser.Error;

/**
 * Special exception that can be used to throw a BPMN Error from {@link JavaDelegate}s and expressions.
 * 
 * This should only be used for business faults, which shall be handled by a Boundary Error Event or Error Event Sub-Process modeled in the process definition. Technical errors should be represented
 * by other exception types.
 * 
 * This class represents an actual instance of a BPMN Error, whereas {@link Error} represents an Error definition.
 * 
 * @author Tijs Rademakers
 */
class BpmnError : FlowableException {

    private static final long serialVersionUID = 1L;

    private string errorCode;

    this(string errorCode) {
        super("");
        setErrorCode(errorCode);
    }

    this(string errorCode, string message) {
        super(message);
        setErrorCode(errorCode);
    }

    protected void setErrorCode(string errorCode) {
        if (errorCode == null) {
            throw new FlowableIllegalArgumentException("Error Code must not be null.");
        }
        if (errorCode.length() < 1) {
            throw new FlowableIllegalArgumentException("Error Code must not be empty.");
        }
        this.errorCode = errorCode;
    }

    public string getErrorCode() {
        return errorCode;
    }
}
