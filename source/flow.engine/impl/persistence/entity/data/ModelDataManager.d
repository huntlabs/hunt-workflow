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


import hunt.collection.List;
import hunt.collection.Map;

import flow.common.persistence.entity.data.DataManager;
import flow.engine.impl.ModelQueryImpl;
import flow.engine.impl.persistence.entity.ModelEntity;
import flow.engine.repository.Model;

/**
 * @author Joram Barrez
 */
interface ModelDataManager extends DataManager<ModelEntity> {

    List<Model> findModelsByQueryCriteria(ModelQueryImpl query);

    long findModelCountByQueryCriteria(ModelQueryImpl query);

    List<Model> findModelsByNativeQuery(Map!(string, Object) parameterMap);

    long findModelCountByNativeQuery(Map!(string, Object) parameterMap);

}
