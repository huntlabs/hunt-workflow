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
import org.flowable.bpmn.model.GraphicInfo;

class Problem {

    protected string errorMessage;
    protected string resource;
    protected int line;
    protected int column;

    public Problem(string errorMessage, string localName, int lineNumber, int columnNumber) {
        this.errorMessage = errorMessage;
        this.resource = localName;
        this.line = lineNumber;
        this.column = columnNumber;
    }

    public Problem(string errorMessage, BaseElement element) {
        this.errorMessage = errorMessage;
        this.resource = element.getId();
        this.line = element.getXmlRowNumber();
        this.column = element.getXmlColumnNumber();
    }

    public Problem(string errorMessage, GraphicInfo graphicInfo) {
        this.errorMessage = errorMessage;
        this.line = graphicInfo.getXmlRowNumber();
        this.column = graphicInfo.getXmlColumnNumber();
    }

    @Override
    public string toString() {
        return errorMessage + (resource !is null ? " | " + resource : "") + " | line " + line + " | column " + column;
    }
}
