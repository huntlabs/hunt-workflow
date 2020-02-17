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
import java.util.HashMap;
import java.util.Map;

/**
 * @author Tijs Rademakers
 */
class ProcessDefinitionInfoEntityImpl extends AbstractBpmnEngineEntity implements ProcessDefinitionInfoEntity, Serializable {

    private static final long serialVersionUID = 1L;

    protected string processDefinitionId;
    protected string infoJsonId;

    public ProcessDefinitionInfoEntityImpl() {

    }

    @Override
    public Object getPersistentState() {
        Map<string, Object> persistentState = new HashMap<>();
        persistentState.put("processDefinitionId", this.processDefinitionId);
        persistentState.put("infoJsonId", this.infoJsonId);
        return persistentState;
    }

    // getters and setters //////////////////////////////////////////////////////

    @Override
    public string getProcessDefinitionId() {
        return processDefinitionId;
    }

    @Override
    public void setProcessDefinitionId(string processDefinitionId) {
        this.processDefinitionId = processDefinitionId;
    }

    @Override
    public string getInfoJsonId() {
        return infoJsonId;
    }

    @Override
    public void setInfoJsonId(string infoJsonId) {
        this.infoJsonId = infoJsonId;
    }
}
