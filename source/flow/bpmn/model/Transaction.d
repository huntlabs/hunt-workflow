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
module flow.bpmn.model.Transaction;

import flow.bpmn.model.SubProcess;
import flow.bpmn.model.FlowNode;
import flow.bpmn.model.Activity;
import flow.bpmn.model.FlowElement;
class Transaction : SubProcess {
  alias setValues = FlowElement.setValues;
  alias setValues = FlowNode.setValues;
  alias setValues = Activity.setValues;
  alias setValues = SubProcess.setValues;

  override
    string getClassType()
  {
    return "transaction";
  }
}
