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

module flow.idm.engine.impl.persistence.entity.data.TokenDataManager;

import hunt.collection.List;
import hunt.collection.Map;

import flow.common.persistence.entity.data.DataManager;
import flow.idm.api.Token;
import flow.idm.engine.impl.TokenQueryImpl;
import flow.idm.engine.impl.persistence.entity.TokenEntity;

/**
 * @author Tijs Rademakers
 */
interface TokenDataManager : DataManager!TokenEntity {

    List!Token findTokenByQueryCriteria(TokenQueryImpl query);

    long findTokenCountByQueryCriteria(TokenQueryImpl query);

    List!Token findTokensByNativeQuery(Map!(string, Object) parameterMap);

    long findTokenCountByNativeQuery(Map!(string, Object) parameterMap);
}
