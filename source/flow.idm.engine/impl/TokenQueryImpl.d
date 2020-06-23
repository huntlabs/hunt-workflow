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

module flow.idm.engine.impl.TokenQueryImpl;

import hunt.collection.List;

import flow.common.api.FlowableIllegalArgumentException;
import flow.common.api.query.QueryCacheValues;
import flow.common.interceptor.CommandContext;
import flow.common.interceptor.CommandExecutor;
import flow.common.query.AbstractQuery;
import flow.idm.api.Token;
import flow.idm.api.TokenQuery;
import flow.idm.api.TokenQueryProperty;
import flow.idm.engine.impl.util.CommandContextUtil;

/**
 * @author Tijs Rademakers
 */
class TokenQueryImpl : AbstractQuery!(TokenQuery, Token) , TokenQuery, QueryCacheValues {

    protected string id;
    protected List!string ids;
    protected string _tokenValue;
    protected Date _tokenDate;
    protected Date _tokenDateBefore;
    protected Date _tokenDateAfter;
    protected string _ipAddress;
    protected string _ipAddressLike;
    protected string _userAgent;
    protected string _userAgentLike;
    protected string _userId;
    protected string _userIdLike;
    protected string _tokenData;
    protected string _tokenDataLike;

    this() {
    }

    this(CommandContext commandContext) {
        super(commandContext);
    }

    this(CommandExecutor commandExecutor) {
        super(commandExecutor);
    }


    public TokenQuery tokenId(string id) {
        if (id is null) {
            throw new FlowableIllegalArgumentException("Provided id is null");
        }
        this.id = id;
        return this;
    }


    public TokenQuery tokenIds(List!string ids) {
        if (ids is null) {
            throw new FlowableIllegalArgumentException("Provided ids is null");
        }
        this.ids = ids;
        return this;
    }


    public TokenQuery tokenValue(string tokenValue) {
        if (tokenValue is null) {
            throw new FlowableIllegalArgumentException("Provided token value is null");
        }
        this._tokenValue = tokenValue;
        return this;
    }


    public TokenQuery tokenDate(Date tokenDate) {
        if (tokenDate is null) {
            throw new FlowableIllegalArgumentException("Provided token date is null");
        }
        this._tokenDate = tokenDate;
        return this;
    }


    public TokenQuery tokenDateBefore(Date tokenDateBefore) {
        if (tokenDateBefore is null) {
            throw new FlowableIllegalArgumentException("Provided tokenDateBefore is null");
        }
        this._tokenDateBefore = tokenDateBefore;
        return this;
    }


    public TokenQuery tokenDateAfter(Date tokenDateAfter) {
        if (tokenDateAfter is null) {
            throw new FlowableIllegalArgumentException("Provided tokenDateAfter is null");
        }
        this._tokenDateAfter = tokenDateAfter;
        return this;
    }


    public TokenQuery ipAddress(string ipAddress) {
        if (ipAddress is null) {
            throw new FlowableIllegalArgumentException("Provided ip address is null");
        }
        this._ipAddress = ipAddress;
        return this;
    }


    public TokenQuery ipAddressLike(string ipAddressLike) {
        if (ipAddressLike is null) {
            throw new FlowableIllegalArgumentException("Provided ipAddressLike is null");
        }
        this._ipAddressLike = ipAddressLike;
        return this;
    }


    public TokenQuery userAgent(string userAgent) {
        if (userAgent is null) {
            throw new FlowableIllegalArgumentException("Provided user agent is null");
        }
        this._userAgent = userAgent;
        return this;
    }


    public TokenQuery userAgentLike(string userAgentLike) {
        if (userAgentLike is null) {
            throw new FlowableIllegalArgumentException("Provided userAgentLike is null");
        }
        this._userAgentLike = userAgentLike;
        return this;
    }


    public TokenQuery userId(string userId) {
        if (userId is null) {
            throw new FlowableIllegalArgumentException("Provided user id is null");
        }
        this._userId = userId;
        return this;
    }


    public TokenQuery userIdLike(string userIdLike) {
        if (userIdLike is null) {
            throw new FlowableIllegalArgumentException("Provided userIdLike is null");
        }
        this._userIdLike = userIdLike;
        return this;
    }


    public TokenQuery tokenData(string tokenData) {
        if (tokenData is null) {
            throw new FlowableIllegalArgumentException("Provided token data is null");
        }
        this._tokenData = tokenData;
        return this;
    }


    public TokenQuery tokenDataLike(string tokenDataLike) {
        if (tokenDataLike is null) {
            throw new FlowableIllegalArgumentException("Provided tokenDataLike is null");
        }
        this._tokenDataLike = tokenDataLike;
        return this;
    }

    // sorting //////////////////////////////////////////////////////////


    public TokenQuery orderByTokenId() {
        return orderBy(TokenQueryProperty.TOKEN_ID);
    }


    public TokenQuery orderByTokenDate() {
        return orderBy(TokenQueryProperty.TOKEN_DATE);
    }

    // results //////////////////////////////////////////////////////////

    override
    public long executeCount(CommandContext commandContext) {
        return CommandContextUtil.getTokenEntityManager(commandContext).findTokenCountByQueryCriteria(this);
    }

    override
    public List!Token executeList(CommandContext commandContext) {
        return CommandContextUtil.getTokenEntityManager(commandContext).findTokenByQueryCriteria(this);
    }

    // getters //////////////////////////////////////////////////////////


    public string getId() {
        return id;
    }

    public List!string getIds() {
        return ids;
    }

    public string getTokenValue() {
        return _tokenValue;
    }

    public Date getTokenDate() {
        return _tokenDate;
    }

    public Date getTokenDateBefore() {
        return _tokenDateBefore;
    }

    public Date getTokenDateAfter() {
        return _tokenDateAfter;
    }

    public string getIpAddress() {
        return _ipAddress;
    }

    public string getIpAddressLike() {
        return _ipAddressLike;
    }

    public string getUserAgent() {
        return _userAgent;
    }

    public string getUserAgentLike() {
        return _userAgentLike;
    }

    public string getUserId() {
        return _userId;
    }

    public string getUserIdLike() {
        return _userIdLike;
    }

    public string getTokenData() {
        return _tokenData;
    }

    public string getTokenDataLike() {
        return _tokenDataLike;
    }
}
