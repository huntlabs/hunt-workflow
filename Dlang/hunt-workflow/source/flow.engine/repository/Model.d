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


import java.util.Date;

/**
 * Represents a model that is stored in the model repository. In addition, a model can be deployed to the process Engine in a separate deployment step.
 * 
 * A model is a container for the meta data and sources of a process model that typically can be edited in a modeling environment.
 * 
 * @author Tijs Rademakers
 * @author Joram Barrez
 */
interface Model {

    string getId();

    string getName();

    void setName(string name);

    string getKey();

    void setKey(string key);

    string getCategory();

    void setCategory(string category);

    Date getCreateTime();

    Date getLastUpdateTime();

    Integer getVersion();

    void setVersion(Integer version);

    string getMetaInfo();

    void setMetaInfo(string metaInfo);

    string getDeploymentId();

    void setDeploymentId(string deploymentId);

    void setTenantId(string tenantId);

    string getTenantId();

    /** whether this model has editor source */
    bool hasEditorSource();

    /** whether this model has editor source extra */
    bool hasEditorSourceExtra();
}
