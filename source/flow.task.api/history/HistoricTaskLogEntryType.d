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

module flow.task.api.history.HistoricTaskLogEntryType;


import flow.common.api.deleg.event.FlowableEventType;
import std.concurrency : initOnce;
import hunt.Enum;
/**
 * @author Tijs Rademakers
 */
//class AssociationDirection :AbstractEnum!AssociationDirection {
//
//   static AssociationDirection NONE() {
//     __gshared AssociationDirection  inst;
//     return initOnce!inst(inst = new AssociationDirection!("None", 0));
//   }
/**
 * @author martin.grofcik
 */
class HistoricTaskLogEntryType : AbstractEnum!string , FlowableEventType {

    this (string name , int val)
    {
      super(name, val);
    }

   static HistoricTaskLogEntryType USER_TASK_COMPLETED() {
     __gshared HistoricTaskLogEntryType  inst;
     return initOnce!inst(inst = new HistoricTaskLogEntryType!("USER_TASK_COMPLETED", 0));
   }
   static HistoricTaskLogEntryType USER_TASK_ASSIGNEE_CHANGED() {
     __gshared HistoricTaskLogEntryType  inst;
     return initOnce!inst(inst = new HistoricTaskLogEntryType!("USER_TASK_ASSIGNEE_CHANGED", 1));
   }
   static HistoricTaskLogEntryType USER_TASK_CREATED() {
     __gshared HistoricTaskLogEntryType  inst;
     return initOnce!inst(inst = new HistoricTaskLogEntryType!("USER_TASK_CREATED", 2));
   }
   static HistoricTaskLogEntryType USER_TASK_OWNER_CHANGED() {
     __gshared HistoricTaskLogEntryType  inst;
     return initOnce!inst(inst = new HistoricTaskLogEntryType!("USER_TASK_OWNER_CHANGED", 3));
   }
   static HistoricTaskLogEntryType USER_TASK_PRIORITY_CHANGED() {
     __gshared HistoricTaskLogEntryType  inst;
     return initOnce!inst(inst = new HistoricTaskLogEntryType!("USER_TASK_PRIORITY_CHANGED", 4));
   }
   static HistoricTaskLogEntryType USER_TASK_DUEDATE_CHANGED() {
     __gshared HistoricTaskLogEntryType  inst;
     return initOnce!inst(inst = new HistoricTaskLogEntryType!("USER_TASK_DUEDATE_CHANGED", 5));
   }
   static HistoricTaskLogEntryType USER_TASK_NAME_CHANGED() {
     __gshared HistoricTaskLogEntryType  inst;
     return initOnce!inst(inst = new HistoricTaskLogEntryType!("USER_TASK_NAME_CHANGED", 6));
   }
   static HistoricTaskLogEntryType USER_TASK_SUSPENSIONSTATE_CHANGED() {
     __gshared HistoricTaskLogEntryType  inst;
     return initOnce!inst(inst = new HistoricTaskLogEntryType!("USER_TASK_SUSPENSIONSTATE_CHANGED", 7));
   }
   static HistoricTaskLogEntryType USER_TASK_IDENTITY_LINK_ADDED() {
     __gshared HistoricTaskLogEntryType  inst;
     return initOnce!inst(inst = new HistoricTaskLogEntryType!("USER_TASK_IDENTITY_LINK_ADDED", 8));
   }
   static HistoricTaskLogEntryType USER_TASK_IDENTITY_LINK_REMOVED() {
     __gshared HistoricTaskLogEntryType  inst;
     return initOnce!inst(inst = new HistoricTaskLogEntryType!("USER_TASK_IDENTITY_LINK_REMOVED", 9));
   }

  string name()
  {
    return super.name;
  }
    //USER_TASK_COMPLETED,
    //USER_TASK_ASSIGNEE_CHANGED,
    //USER_TASK_CREATED,
    //USER_TASK_OWNER_CHANGED,
    //USER_TASK_PRIORITY_CHANGED,
    //USER_TASK_DUEDATE_CHANGED,
    //USER_TASK_NAME_CHANGED,
    //USER_TASK_SUSPENSIONSTATE_CHANGED,
    //USER_TASK_IDENTITY_LINK_ADDED,
    //USER_TASK_IDENTITY_LINK_REMOVED
}
