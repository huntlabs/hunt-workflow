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
module flow.engine.impl.persistence.entity.ModelEntityManager;

import hunt.collection.List;
import hunt.collection.Map;

import flow.common.persistence.entity.EntityManager;
import flow.engine.impl.ModelQueryImpl;
import flow.engine.repository.Model;
import flow.engine.impl.persistence.entity.ModelEntity;
/**
 * @author Joram Barrez
 */
interface ModelEntityManager : EntityManager!ModelEntity {

    void insertEditorSourceForModel(string modelId, byte[] modelSource);

    void insertEditorSourceExtraForModel(string modelId, byte[] modelSource);

    List!Model findModelsByQueryCriteria(ModelQueryImpl query);

    long findModelCountByQueryCriteria(ModelQueryImpl query);

    byte[] findEditorSourceByModelId(string modelId);

    byte[] findEditorSourceExtraByModelId(string modelId);

    List!Model findModelsByNativeQuery(Map!(string, Object) parameterMap);

    long findModelCountByNativeQuery(Map!(string, Object) parameterMap);

    void updateModel(ModelEntity updatedModel);

    void deleteEditorSource(ModelEntity model);

    void deleteEditorSourceExtra(ModelEntity model);

}
