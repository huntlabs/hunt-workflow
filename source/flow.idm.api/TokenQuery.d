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
import java.util.List;

import flow.common.api.query.Query;

/**
 * Allows programmatic querying of {@link Token}
 * 
 * @author Tijs Rademakers
 */
interface TokenQuery extends Query<TokenQuery, Token> {

    /** Only select {@link Token}s with the given id/ */
    TokenQuery tokenId(string id);

    /** Only select {@link Token}s with the given ids/ */
    TokenQuery tokenIds(List<string> ids);

    /** Only select {@link Token}s with the given token value. */
    TokenQuery tokenValue(string tokenValue);

    /**
     * Only select {@link Token}s that have a token date on the given date.
     */
    TokenQuery tokenDate(Date tokenDate);

    /**
     * Only select {@link Token}s that have a token date before the given date.
     */
    TokenQuery tokenDateBefore(Date before);

    /**
     * Only select {@link Token}s that have a token date after the given date.
     */
    TokenQuery tokenDateAfter(Date after);

    /** Only select {@link Token}s with the given ip address. */
    TokenQuery ipAddress(string ipAddress);

    /**
     * Only select {@link Token}s where the ip address matches the given parameter. The syntax is that of SQL, eg. %127%.
     */
    TokenQuery ipAddressLike(string ipAddressLike);

    /** Only select {@link Token}s with the given user agent. */
    TokenQuery userAgent(string userAgent);

    /**
     * Only select {@link Token}s where the user agent matches the given parameter. The syntax is that of SQL, eg. %chrome%.
     */
    TokenQuery userAgentLike(string userAgentLike);

    /** Only select {@link Token}s with the given user id. */
    TokenQuery userId(string userId);

    /**
     * Only select {@link Token}s where the user id matches the given parameter. The syntax is that of SQL, eg. %test%.
     */
    TokenQuery userIdLike(string userIdLike);

    /** Only select {@link Token}s with the given token data. */
    TokenQuery tokenData(string tokenData);

    /**
     * Only select {@link Token}s where the token data matches the given parameter. The syntax is that of SQL, eg. %test%.
     */
    TokenQuery tokenDataLike(string tokenDataLike);

    // sorting ////////////////////////////////////////////////////////

    /**
     * Order by token id (needs to be followed by {@link #asc()} or {@link #desc()}).
     */
    TokenQuery orderByTokenId();

    /**
     * Order by token date (needs to be followed by {@link #asc()} or {@link #desc()}).
     */
    TokenQuery orderByTokenDate();
}
