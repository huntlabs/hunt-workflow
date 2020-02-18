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


import org.flowable.bpmn.model.BaseElement;

class Warning {

    protected string warningMessage;
    protected string resource;
    protected int line;
    protected int column;

    public Warning(string warningMessage, string localName, int lineNumber, int columnNumber) {
        this.warningMessage = warningMessage;
        this.resource = localName;
        this.line = lineNumber;
        this.column = columnNumber;
    }

    public Warning(string warningMessage, BaseElement element) {
        this.warningMessage = warningMessage;
        this.resource = element.getId();
        line = element.getXmlRowNumber();
        column = element.getXmlColumnNumber();
    }

    @Override
    public string toString() {
        return warningMessage + (resource !is null ? " | " + resource : "") + " | line " + line + " | column " + column;
    }
}
