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

module flow.bpmn.model.AssociationDirection;
import std.concurrency : initOnce;
import hunt.Enum;
/**
 * @author Tijs Rademakers
 */
class AssociationDirection :AbstractEnum!AssociationDirection {

   static AssociationDirection NONE() {
         __gshared AssociationDirection  inst;
         return initOnce!inst(inst = new AssociationDirection!("NONE", 0));
     }

     static AssociationDirection ONE() {
       __gshared AssociationDirection  inst;
       return initOnce!inst(inst = new AssociationDirection!("ONE", 1));
     }

       static AssociationDirection BOTH() {
         __gshared AssociationDirection  inst;
         return initOnce!inst(inst = new AssociationDirection!("BOTH", 2));
       }

    string value;

    this(string value ,int v) {
        this.value = value;
        super(value,v);
    }


  static AssociationDirection[] values() {
    __gshared AssociationDirection[] _e;
    return initOnce!(_e)({
      AssociationDirection[] _ENUMS;
      if(_ENUMS.length == 0) {
        _ENUMS ~= NONE;
        _ENUMS ~= ONE;
        _ENUMS ~= BOTH;
      }
      return _ENUMS;
    }());
  }

    public string getValue() {
        return value;
    }
}
