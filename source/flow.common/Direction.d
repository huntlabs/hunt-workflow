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

module flow.common.Direction;





import hunt.collection.HashMap;
import hunt.collection.Map;
import std.concurrency : initOnce;
/**
 * @author Tom Baeyens
 */
class Direction {

   // private static  Map<string, Direction> directions = new HashMap<>();

    //public static final Direction ASCENDING = new Direction("asc");
    //public static final Direction DESCENDING = new Direction("desc");


     static Map!(string,Direction)  directions() {
       __gshared Map!(string,Direction)  inst;
       return initOnce!inst(new HashMap!(string,Direction));
     }

  static Direction  ASCENDING() {
    __gshared Direction  inst;
    return initOnce!inst(new Direction("asc"));
  }

  static Direction  DESCENDING() {
    __gshared Direction  inst;
    return initOnce!inst(new Direction("desc"));
  }
    private string name;

    this(string name) {
        this.name = name;
        directions.put(name, this);
    }

    public string getName() {
        return name;
    }

    public static Direction findByName(string directionName) {
        return directions.get(directionName);
    }
}
