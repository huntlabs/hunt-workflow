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
 
module flow.engine.repository.MergeMode;
 
 
 import hunt.Enum;
import std.concurrency : initOnce;


/**
 * @author Valentin Zickner
 */
class MergeMode : AbstractEnum!MergeMode {

    static MergeMode  VERIFY() {
      __gshared MergeMode  inst;
      return initOnce!inst(new MergeMode("verify" , 0));
    }

   static MergeMode  AS_NEW() {
       __gshared MergeMode  inst;
       return initOnce!inst(new MergeMode("as-new" , 1));
   }

  static MergeMode  AS_OLD() {
      __gshared MergeMode  inst;
      return initOnce!inst(new MergeMode("as-old" , 2));
  }

    static MergeMode  BY_DATE() {
        __gshared MergeMode  inst;
        return initOnce!inst(new MergeMode("by-date" , 3));
    }
    protected string name;

    this(string name ,int val) {
        this.name = name;
        super(name,val);
    }

    public string getName() {
        return name;
    }

}
