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

module flow.idm.api.UserQueryProperty;

import hunt.collection.HashMap;
import hunt.collection.Map;

import flow.common.api.query.QueryProperty;
import std.concurrency : initOnce;


/**
 * Contains the possible properties that can be used by the {@link UserQuery}.
 *
 * @author Joram Barrez
 */
class UserQueryProperty :  QueryProperty {

    private static  long serialVersionUID = 1L;

    //private static  Map!(string, UserQueryProperty) properties  ;//= new HashMap<>();
    //
    //public static  UserQueryProperty USER_ID = new UserQueryProperty("RES.ID_");
    //public static  UserQueryProperty FIRST_NAME = new UserQueryProperty("RES.FIRST_");
    //public static  UserQueryProperty LAST_NAME = new UserQueryProperty("RES.LAST_");
    //public static  UserQueryProperty DISPLAY_NAME = new UserQueryProperty("RES.DISPLAY_NAME_");
    //public static  UserQueryProperty EMAIL = new UserQueryProperty("RES.EMAIL_");


    static Map!(string, UserQueryProperty) properties() {
      __gshared Map!(string, UserQueryProperty) inst;
      return initOnce!inst(new HashMap!(string, UserQueryProperty));
    }

  static UserQueryProperty USER_ID() {
    __gshared UserQueryProperty inst;
    return initOnce!inst(new UserQueryProperty("RES.ID_"));
  }
  static UserQueryProperty FIRST_NAME() {
    __gshared UserQueryProperty inst;
    return initOnce!inst(new UserQueryProperty("RES.FIRST_"));
  }
  static UserQueryProperty LAST_NAME() {
    __gshared UserQueryProperty inst;
    return initOnce!inst(new UserQueryProperty("RES.LAST_"));
  }
  static UserQueryProperty DISPLAY_NAME() {
    __gshared UserQueryProperty inst;
    return initOnce!inst(new UserQueryProperty("RES.DISPLAY_NAME_"));
  }
  static UserQueryProperty EMAIL() {
    __gshared UserQueryProperty inst;
    return initOnce!inst(new UserQueryProperty("RES.EMAIL_"));
  }
  private string name;

    this(string name) {
        this.name = name;
        properties.put(name, this);
    }

    public string getName() {
        return name;
    }

    public static UserQueryProperty findByName(string propertyName) {
        return properties.get(propertyName);
    }

}
