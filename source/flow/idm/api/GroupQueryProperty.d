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

module flow.idm.api.GroupQueryProperty;


import hunt.collection.HashMap;
import hunt.collection.Map;
import std.concurrency : initOnce;
import flow.common.api.query.QueryProperty;

/**
 * Contains the possible properties that can be used by the {@link GroupQuery}.
 *
 * @author Joram Barrez
 */
class GroupQueryProperty : QueryProperty {

    private static  long serialVersionUID = 1L;

    //private static  Map!(string, GroupQueryProperty) properties ;// = new HashMap<>();
    //
    //public static  GroupQueryProperty GROUP_ID = new GroupQueryProperty("RES.ID_");
    //public static  GroupQueryProperty NAME = new GroupQueryProperty("RES.NAME_");
    //public static  GroupQueryProperty TYPE = new GroupQueryProperty("RES.TYPE_");

    private string name;


  static Map!(string, GroupQueryProperty) properties() {
    __gshared Map!(string, GroupQueryProperty) inst;
    return initOnce!inst(new HashMap!(string, GroupQueryProperty));
  }

  static GroupQueryProperty GROUP_ID() {
    __gshared GroupQueryProperty inst;
    return initOnce!inst(new GroupQueryProperty("RES.ID_"));
  }
  static GroupQueryProperty NAME() {
    __gshared GroupQueryProperty inst;
    return initOnce!inst(new GroupQueryProperty("RES.NAME_"));
  }
  static GroupQueryProperty TYPE() {
    __gshared GroupQueryProperty inst;
    return initOnce!inst(new GroupQueryProperty("RES.TYPE_"));
  }

    this(string name) {
        this.name = name;
        properties.put(name, this);
    }

    public string getName() {
        return name;
    }

    public static GroupQueryProperty findByName(string propertyName) {
        return properties.get(propertyName);
    }

}
