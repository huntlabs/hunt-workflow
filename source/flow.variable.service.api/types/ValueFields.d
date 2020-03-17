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

module flow.variable.service.api.types.ValueFields;

import hunt.Long;
import hunt.Double;
/**
 * Common interface for regular and historic variable entities.
 *
 * @author Tom Baeyens
 */
interface ValueFields {

    /**
     * @return the name of the variable
     */
    string getName();

    /**
     * @return the process instance id of the variable
     */
    string getProcessInstanceId();

    /**
     * @return the execution id of the variable
     */
    string getExecutionId();

    /**
     * @return the scope id of the variable
     */
    string getScopeId();

    /**
     * @return the sub scope id of the variable
     */
    string getSubScopeId();

    /**
     * @return the scope type of the variable
     */
    string getScopeType();

    /**
     * @return the task id of the variable
     */
    string getTaskId();

    /**
     * @return the first text value, if any, or null.
     */
    string getTextValue();

    /**
     * Sets the first text value. A value of null is allowed.
     */
    void setTextValue(string textValue);

    /**
     * @return the second text value, if any, or null.
     */
    string getTextValue2();

    /**
     * Sets second text value. A value of null is allowed.
     */
    void setTextValue2(string textValue2);

    /**
     * @return the long value, if any, or null.
     */
    Long getLongValue();

    /**
     * Sets the long value. A value of null is allowed.
     */
    void setLongValue(Long longValue);

    /**
     * @return the double value, if any, or null.
     */
    Double getDoubleValue();

    /**
     * Sets the double value. A value of null is allowed.
     */
    void setDoubleValue(Double doubleValue);

    /**
     * @return the byte array value, if any, or null.
     */
    byte[] getBytes();

    /**
     * Sets the byte array value. A value of null is allowed.
     */
    void setBytes(byte[] bytes);

    Object getCachedValue();

    void setCachedValue(Object cachedValue);

}
