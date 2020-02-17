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
import java.util.List;
import java.util.Map;

import org.flowable.bpmn.model.FormProperty;
import flow.engine.impl.persistence.entity.DeploymentEntity;
import flow.engine.impl.persistence.entity.ExecutionEntity;
import flow.engine.repository.ProcessDefinition;

/**
 * @author Tom Baeyens
 */
interface FormHandler extends Serializable {

    ThreadLocal<FormHandler> current = new ThreadLocal<>();

    void parseConfiguration(List<FormProperty> formProperties, string formKey, DeploymentEntity deployment, ProcessDefinition processDefinition);

    void submitFormProperties(Map<string, string> properties, ExecutionEntity execution);
}
