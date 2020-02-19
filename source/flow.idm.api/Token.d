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

//          Copyright linse 2020. 
// Distributed under the Boost Software License, Version 1.0. 
//    (See accompanying file LICENSE_1_0.txt or copy at 
//          http://www.boost.org/LICENSE_1_0.txt)} 
 
module flow.idm.api.Token;



import hunt.time.LocalDateTime;
alias Date = LocalDateTime;

//import java.io.Serializable;

/**
 * @author Tijs Rademakers
 */
interface Token  {

    string getId();

    string getTokenValue();

    void setTokenValue(string tokenValue);

    Date getTokenDate();

    void setTokenDate(Date tokenDate);

    string getIpAddress();

    void setIpAddress(string ipAddress);

    string getUserAgent();

    void setUserAgent(string userAgent);

    string getUserId();

    void setUserId(string userId);

    string getTokenData();

    void setTokenData(string tokenData);
}
