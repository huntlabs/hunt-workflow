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
import java.util.Comparator;

/**
 * @author Daniel Meyer
 */
class ErrorEventDefinition implements Serializable {

    public static Comparator!ErrorEventDefinition comparator = new Comparator!ErrorEventDefinition() {
        override
        public int compare(ErrorEventDefinition o1, ErrorEventDefinition o2) {
            return o2.getPrecedence().compareTo(o1.getPrecedence());
        }
    };

    private static final long serialVersionUID = 1L;

    protected final string handlerActivityId;
    protected string errorCode;
    protected Integer precedence = 0;

    public ErrorEventDefinition(string handlerActivityId) {
        this.handlerActivityId = handlerActivityId;
    }

    public string getErrorCode() {
        return errorCode;
    }

    public void setErrorCode(string errorCode) {
        this.errorCode = errorCode;
    }

    public string getHandlerActivityId() {
        return handlerActivityId;
    }

    public Integer getPrecedence() {
        // handlers with error code take precedence over catchall-handlers
        return precedence + (errorCode !is null ? 1 : 0);
    }

    public void setPrecedence(Integer precedence) {
        this.precedence = precedence;
    }

    public bool catches(string errorCode) {
        return errorCode is null || this.errorCode is null || this.errorCode.equals(errorCode);
    }

}
