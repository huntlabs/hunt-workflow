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

module flow.bpmn.model.FlowElementsContainer;

import hunt.collection;
import hunt.collection.Map;
import flow.bpmn.model.FlowElement;
import flow.bpmn.model.Artifact;
/**
 * @author Tijs Rademakers
 */
interface FlowElementsContainer {

    FlowElement getFlowElement(string id);

    Collection!FlowElement getFlowElements();

    Map!(string, FlowElement) getFlowElementMap();

    void addFlowElement(FlowElement element);

    void addFlowElementToMap(FlowElement element);

    void removeFlowElement(string elementId);

    void removeFlowElementFromMap(string elementId);

    Artifact getArtifact(string id);

    Collection!Artifact getArtifacts();

    void addArtifact(Artifact artifact);

    void removeArtifact(string artifactId);
}
