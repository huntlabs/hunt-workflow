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

module flow.idm.api.TokenQueryProperty;

import hunt.collection.HashMap;
import hunt.collection.Map;

import flow.common.api.query.QueryProperty;
import std.concurrency : initOnce;
/**
 * Contains the possible properties that can be used by the {@link TokenQuery}.
 *
 * @author Tijs Rademakers
 */
class TokenQueryProperty : QueryProperty {

    private static  long serialVersionUID = 1L;

   // private static  Map!(string, TokenQueryProperty) properties  ;//= new HashMap<>();

    //public static  TokenQueryProperty TOKEN_ID = new TokenQueryProperty("RES.ID_");
    //public static  TokenQueryProperty TOKEN_DATE = new TokenQueryProperty("RES.TOKEN_DATE_");

    private string name;


  static Map!(string, TokenQueryProperty) properties() {
    __gshared Map!(string, TokenQueryProperty) inst;
    return initOnce!inst(new HashMap!(string, TokenQueryProperty));
  }

  static TokenQueryProperty TOKEN_ID() {
    __gshared TokenQueryProperty inst;
    return initOnce!inst(new TokenQueryProperty("RES.ID_"));
  }
  static TokenQueryProperty TOKEN_DATE() {
    __gshared TokenQueryProperty inst;
    return initOnce!inst(new TokenQueryProperty("RES.TOKEN_DATE_"));
  }
    this(string name) {
        this.name = name;
        properties.put(name, this);
    }

    public string getName() {
        return name;
    }

    public static TokenQueryProperty findByName(string propertyName) {
        return properties.get(propertyName);
    }

}
