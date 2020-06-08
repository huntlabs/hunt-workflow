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



import flow.engine.form.AbstractFormType;

/**
 * @author Tom Baeyens
 */
class StringFormType : AbstractFormType {

    private static final long serialVersionUID = 1L;

    override
    public string getName() {
        return "string";
    }

    public string getMimeType() {
        return "text/plain";
    }

    override
    public Object convertFormValueToModelValue(string propertyValue) {
        return propertyValue;
    }

    override
    public string convertModelValueToFormValue(Object modelValue) {
        return (string) modelValue;
    }

}
