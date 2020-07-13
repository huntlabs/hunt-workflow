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
module flow.variable.service.impl.persistence.entity.TransientVariableInstance;

import flow.variable.service.api.deleg.VariableScope;
import flow.variable.service.api.persistence.entity.VariableInstance;
import hunt.Long;
import hunt.Double;
/**
 * A dummy implementation of {@link VariableInstance}, used for storing transient variables on a {@link VariableScope}, as the {@link VariableScope} works with instances of {@link VariableInstance}
 * and not with raw key/values.
 *
 * Nothing more than a thin wrapper around a name and value. All the other methods are not implemented.
 *
 * @author Joram Barrez
 */
class TransientVariableInstance : VariableInstance {

    public static  string TYPE_TRANSIENT = "transient";

    protected string variableName;
    protected Object variableValue;

    this(string variableName, Object variableValue) {
        this.variableName = variableName;
        this.variableValue = variableValue;
    }


    public string getName() {
        return variableName;
    }


    public string getTextValue() {
        return null;
    }


    public void setTextValue(string textValue) {

    }


    public string getTextValue2() {
        return null;
    }


    public void setTextValue2(string textValue2) {

    }


    public Long getLongValue() {
        return null;
    }


    public void setLongValue(Long longValue) {

    }


    public Double getDoubleValue() {
        return null;
    }


    public void setDoubleValue(Double doubleValue) {

    }


    public byte[] getBytes() {
        return null;
    }


    public void setBytes(byte[] bytes) {

    }


    public Object getCachedValue() {
        return null;
    }


    public void setCachedValue(Object cachedValue) {

    }


    public string getId() {
        return null;
    }


    public void setId(string id) {

    }


    public void setName(string name) {

    }


    public void setProcessInstanceId(string processInstanceId) {

    }


    public void setProcessDefinitionId(string processDefinitionId) {

    }


    public void setExecutionId(string executionId) {

    }


    public Object getValue() {
        return variableValue;
    }


    public void setValue(Object value) {
        variableValue = value;
    }


    public string getTypeName() {
        return TYPE_TRANSIENT;
    }


    public void setTypeName(string typeName) {

    }


    public string getProcessInstanceId() {
        return null;
    }


    public string getProcessDefinitionId() {
        return null;
    }


    public string getTaskId() {
        return null;
    }


    public void setTaskId(string taskId) {

    }


    public string getExecutionId() {
        return null;
    }


    public string getScopeId() {
        return null;
    }


    public string getScopeType() {
        return null;
    }


    public void setScopeId(string scopeId) {

    }


    public string getSubScopeId() {
        return null;
    }


    public void setSubScopeId(string subScopeId) {

    }


    public void setScopeType(string scopeType) {

    }

}
