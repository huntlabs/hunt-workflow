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
//          Copyright linsen 2020.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)}

module flow.bpmn.model.Message;


import flow.bpmn.model.BaseElement;


/**
 * @author Tijs Rademakers
 */
class Message : BaseElement {

    protected string name;
    protected string itemRef;

    this() {
    }

    this(string id, string name, string itemRef) {
        this.id = id;
        this.name = name;
        this.itemRef = itemRef;
    }

    public string getName() {
        return name;
    }

    public void setName(string name) {
        this.name = name;
    }

    public string getItemRef() {
        return itemRef;
    }

    public void setItemRef(string itemRef) {
        this.itemRef = itemRef;
    }

    override
    public Message clone() {
        Message clone = new Message();
        clone.setValues(this);
        return clone;
    }

    public void setValues(Message otherElement) {
        super.setValues(otherElement);
        setName(otherElement.getName());
        setItemRef(otherElement.getItemRef());
    }
}
