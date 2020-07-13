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

module flow.idm.engine.impl.persistence.entity.TokenEntityManagerImpl;

import hunt.collection.List;
import hunt.collection.Map;

import flow.idm.api.Token;
import flow.idm.api.TokenQuery;
import flow.idm.engine.IdmEngineConfiguration;
import flow.idm.engine.impl.TokenQueryImpl;
import flow.idm.engine.impl.persistence.entity.data.TokenDataManager;
import flow.idm.engine.impl.persistence.entity.AbstractIdmEngineEntityManager;
import flow.idm.engine.impl.persistence.entity.TokenEntity;
import flow.idm.engine.impl.persistence.entity.TokenEntityManager;
/**
 * @author Tijs Rademakers
 */
class TokenEntityManagerImpl
    : AbstractIdmEngineEntityManager!(TokenEntity, TokenDataManager)
    , TokenEntityManager {

    this(IdmEngineConfiguration idmEngineConfiguration, TokenDataManager tokenDataManager) {
        super(idmEngineConfiguration, tokenDataManager);
    }


    public Token createNewToken(string tokenId) {
        TokenEntity tokenEntity = create();
        tokenEntity.setId(tokenId);
        tokenEntity.setRevision(0); // needed as tokens can be transient
        return tokenEntity;
    }


    public void updateToken(Token updatedToken) {
        super.update(cast(TokenEntity) updatedToken);
    }


    public bool isNewToken(Token token) {
        return (cast(TokenEntity) token).getRevision() == 0;
    }


    public List!Token findTokenByQueryCriteria(TokenQueryImpl query) {
        return dataManager.findTokenByQueryCriteria(query);
    }


    public long findTokenCountByQueryCriteria(TokenQueryImpl query) {
        return dataManager.findTokenCountByQueryCriteria(query);
    }


    public TokenQuery createNewTokenQuery() {
        return new TokenQueryImpl(getCommandExecutor());
    }


    public List!Token findTokensByNativeQuery(Map!(string, Object) parameterMap) {
        return dataManager.findTokensByNativeQuery(parameterMap);
    }


    public long findTokenCountByNativeQuery(Map!(string, Object) parameterMap) {
        return dataManager.findTokenCountByNativeQuery(parameterMap);
    }
}
