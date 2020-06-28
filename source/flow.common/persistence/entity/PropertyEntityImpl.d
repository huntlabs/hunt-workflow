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

module flow.common.persistence.entity.PropertyEntityImpl;

import flow.common.api.FlowableException;
import  flow.common.persistence.entity.AbstractEntity;
import flow.common.persistence.entity.PropertyEntity;
import hunt.entity;
import hunt.Exceptions;
/**
 * @author Tom Baeyens
 * @author Joram Barrez
 */
@Table("ACT_GE_PROPERTY")
class PropertyEntityImpl : AbstractEntity ,Model, PropertyEntity {
     mixin MakeModel;

    @PrimaryKey
    @Column("NAME_")
     string name;

    @Column("VALUE_")
     string value;

    @Column("REV_")
     int rev;


    public string getIdPrefix() {
        // The name of the property is also the id of the property
        // therefore the id prefix is not needed
        return "";
    }


    public string getName() {
        return name;
    }


    public void setName(string name) {
        this.name = name;
    }


    public string getValue() {
        return value;
    }


    public void setValue(string value) {
        this.value = value;
    }


    public string getId() {
        return name;
    }


    public Object getPersistentState() {
        implementationMissing(false);
        return null;
     //   return value;
    }


    public void setId(string id) {
        throw new FlowableException("only provided id generation allowed for properties");
    }

    // common methods //////////////////////////////////////////////////////////


    override
    public string toString() {
        return "PropertyEntity[name=" ~ name ~ ", value=" ~ value ~ "]";
    }

}
