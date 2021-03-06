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

module flow.task.api.DelegationState;


import hunt.Enum;
import std.concurrency : initOnce;

/**
 * Defines the different states of delegation that a task can be in.
 *
 * @author Tom Baeyens
 */
class DelegationState :AbstractEnum!DelegationState{

    this(string name, int val)
    {
        super(name,val);
    }

    static DelegationState PENDING() {
      __gshared DelegationState  inst;
      return initOnce!inst(inst = new DelegationState("PENDING", 0));
    }

     static DelegationState RESOLVED() {
       __gshared DelegationState  inst;
       return initOnce!inst(inst = new DelegationState("RESOLVED", 1));
     }


  static DelegationState[] values() {
    __gshared DelegationState[] _e;
    return initOnce!(_e)({
      DelegationState[] _ENUMS;
      if(_ENUMS.length == 0) {
        _ENUMS ~= PENDING;
        _ENUMS ~= RESOLVED;
      }
      return _ENUMS;
    }());
  }
    /**
     * The owner delegated the task and wants to review the result after the assignee has resolved the task. When the assignee completes the task, the task is marked as {@link #RESOLVED} and sent back
     * to the owner. When that happens, the owner is set as the assignee so that the owner gets this task back in the ToDo.
     */
    //PENDING,

    /**
     * The assignee has resolved the task, the assignee was set to the owner again and the owner now finds this task back in the ToDo list for review. The owner now is able to complete the task.
     */
    //RESOLVED
}
