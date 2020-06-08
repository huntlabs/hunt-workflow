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



import flow.engine.form.FormProperty;
import flow.engine.form.FormType;

/**
 * @author Tom Baeyens
 */
class FormPropertyImpl implements FormProperty {

    protected string id;
    protected string name;
    protected FormType type;
    protected bool isRequired;
    protected bool isReadable;
    protected bool isWritable;

    protected string value;

    public FormPropertyImpl(FormPropertyHandler formPropertyHandler) {
        this.id = formPropertyHandler.getId();
        this.name = formPropertyHandler.getName();
        this.type = formPropertyHandler.getType();
        this.isRequired = formPropertyHandler.isRequired();
        this.isReadable = formPropertyHandler.isReadable();
        this.isWritable = formPropertyHandler.isWritable();
    }

    override
    public string getId() {
        return id;
    }

    override
    public string getName() {
        return name;
    }

    override
    public FormType getType() {
        return type;
    }

    override
    public string getValue() {
        return value;
    }

    override
    public bool isRequired() {
        return isRequired;
    }

    override
    public bool isReadable() {
        return isReadable;
    }

    public void setValue(string value) {
        this.value = value;
    }

    override
    public bool isWritable() {
        return isWritable;
    }
}
