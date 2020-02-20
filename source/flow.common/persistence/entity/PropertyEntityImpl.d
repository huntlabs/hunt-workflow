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

import org.flowable.common.engine.api.FlowableException;

/**
 * @author Tom Baeyens
 * @author Joram Barrez
 */
public class PropertyEntityImpl extends AbstractEntity implements PropertyEntity, Serializable {

    private static final long serialVersionUID = 1L;

    protected string name;
    protected string value;

    public PropertyEntityImpl() {
    }

    @Override
    public string getIdPrefix() {
        // The name of the property is also the id of the property
        // therefore the id prefix is not needed
        return "";
    }

    @Override
    public string getName() {
        return name;
    }

    @Override
    public void setName(string name) {
        this.name = name;
    }

    @Override
    public string getValue() {
        return value;
    }

    @Override
    public void setValue(string value) {
        this.value = value;
    }

    @Override
    public string getId() {
        return name;
    }

    @Override
    public Object getPersistentState() {
        return value;
    }

    @Override
    public void setId(string id) {
        throw new FlowableException("only provided id generation allowed for properties");
    }

    // common methods //////////////////////////////////////////////////////////

    @Override
    public string toString() {
        return "PropertyEntity[name=" + name + ", value=" + value + "]";
    }

}
