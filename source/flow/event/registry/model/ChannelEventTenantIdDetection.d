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
module flow.event.registry.model.ChannelEventTenantIdDetection;

//import com.fasterxml.jackson.annotation.JsonInclude;
//import com.fasterxml.jackson.annotation.JsonInclude.Include;
/**
 * @author Joram Barrez
 */
//@JsonInclude(Include.NON_NULL)
class ChannelEventTenantIdDetection {

    protected string fixedValue;
    protected string jsonPointerExpression;
    protected string xPathExpression;
    protected string delegateExpression;

    public string getFixedValue() {
        return fixedValue;
    }
    public void setFixedValue(string fixedValue) {
        this.fixedValue = fixedValue;
    }
    public string getJsonPointerExpression() {
        return jsonPointerExpression;
    }
    public void setJsonPointerExpression(string jsonPointerExpression) {
        this.jsonPointerExpression = jsonPointerExpression;
    }
    public string getxPathExpression() {
        return xPathExpression;
    }
    public void setxPathExpression(string xPathExpression) {
        this.xPathExpression = xPathExpression;
    }

    public string getDelegateExpression() {
        return delegateExpression;
    }

    public void setDelegateExpression(string delegateExpression) {
        this.delegateExpression = delegateExpression;
    }
}
