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

module flow.engine.impl.form.FormPropertyImpl;

import flow.engine.form.FormProperty;
import flow.engine.form.FormType;
import flow.engine.impl.form.FormPropertyHandler;
/**
 * @author Tom Baeyens
 */
class FormPropertyImpl : FormProperty {

    protected string id;
    protected string name;
    protected FormType type;
    protected bool _isRequired;
    protected bool _isReadable;
    protected bool _isWritable;

    protected string value;

    this(FormPropertyHandler formPropertyHandler) {
        this.id = formPropertyHandler.getId();
        this.name = formPropertyHandler.getName();
        this.type = formPropertyHandler.getType();
        this._isRequired = formPropertyHandler.isRequired();
        this._isReadable = formPropertyHandler.isReadable();
        this._isWritable = formPropertyHandler.isWritable();
    }


    public string getId() {
        return id;
    }


    public string getName() {
        return name;
    }


    public FormType getType() {
        return type;
    }


    public string getValue() {
        return value;
    }


    public bool isRequired() {
        return _isRequired;
    }


    public bool isReadable() {
        return _isReadable;
    }

    public void setValue(string value) {
        this.value = value;
    }


    public bool isWritable() {
        return _isWritable;
    }
}
