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
module flow.idm.engine.impl.persistence.entity.TokenEntityImpl;

import hunt.collection.HashMap;
import hunt.collection.Map;
import flow.idm.engine.impl.persistence.entity.AbstractIdmEngineEntity;
import flow.idm.engine.impl.persistence.entity.TokenEntity;

import flow.common.db.HasRevision;
import hunt.entity;
import std.conv : to;
/**
 * @author Tom Baeyens
 */

/**
 * @author Tijs Rademakers
 */
@Table("ACT_ID_TOKEN")
class TokenEntityImpl : AbstractIdmEngineEntity ,Model, TokenEntity, HasRevision {

     mixin MakeModel;

    @PrimaryKey
     @Column("ID_")
     string  id;

     @Column("TOKEN_VALUE_")
     string tokenValue;

     @Column("TOKEN_DATE_")
     int tokenDate;

     @Column("IP_ADDRESS_")
     string ipAddress;

     @Column("USER_AGENT_")
     string userAgent;

     @Column("USER_ID_")
     string userId;

     @Column("TOKEN_DATA_")
     string tokenData;


  public string getId() {
      return id;
  }


  public void setId(string id) {
      this.id = id;
  }

    public string getTokenValue() {
        return tokenValue;
    }


    public void setTokenValue(string tokenValue) {
        this.tokenValue = tokenValue;
    }


    public int getTokenDate() {
        return tokenDate;
    }


    public void setTokenDate(int tokenDate) {
        this.tokenDate = tokenDate;
    }


    public string getIpAddress() {
        return ipAddress;
    }


    public void setIpAddress(string ipAddress) {
        this.ipAddress = ipAddress;
    }


    public string getUserAgent() {
        return userAgent;
    }


    public void setUserAgent(string userAgent) {
        this.userAgent = userAgent;
    }


    public string getUserId() {
        return userId;
    }


    public void setUserId(string userId) {
        this.userId = userId;
    }


    public string getTokenData() {
        return tokenData;
    }


    public void setTokenData(string tokenData) {
        this.tokenData = tokenData;
    }


    public Object getPersistentState() {
        Map!(string, string) persistentState = new HashMap!(string, string)();
        persistentState.put("tokenValue", tokenValue);
        persistentState.put("tokenDate", to!string(tokenDate));
        persistentState.put("ipAddress", ipAddress);
        persistentState.put("userAgent", userAgent);
        persistentState.put("userId", userId);
        persistentState.put("tokenData", tokenData);

        return  cast(Object)persistentState;
    }

    // common methods //////////////////////////////////////////////////////////


    override
    public string toString() {
        return "TokenEntity[tokenValue=" ~ tokenValue ~ ", userId=" ~ userId ~ "]";
    }

}
