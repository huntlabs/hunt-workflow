///* Licensed under the Apache License, Version 2.0 (the "License");
// * you may not use this file except in compliance with the License.
// * You may obtain a copy of the License at
// *
// *      http://www.apache.org/licenses/LICENSE-2.0
// *
// * Unless required by applicable law or agreed to in writing, software
// * distributed under the License is distributed on an "AS IS" BASIS,
// * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// * See the License for the specific language governing permissions and
// * limitations under the License.
// */
//
//
//import hunt.collection.Map;
//
///**
// * @author Dennis
// */
//interface ActivityMigrationMappingOptions<T : ActivityMigrationMapping> {
//
//    T inParentProcessOfCallActivityId(string callActivityId);
//
//    string getFromCallActivityId();
//
//    bool isToParentProcess();
//
//    T inSubProcessOfCallActivityId(string callActivityId);
//
//    T inSubProcessOfCallActivityId(string callActivityId, int subProcessDefVersion);
//
//    string getToCallActivityId();
//
//    Integer getCallActivityProcessDefinitionVersion();
//
//    bool isToCallActivity();
//
//    interface SingleToActivityOptions <T : ActivityMigrationMapping> : ActivityMigrationMappingOptions!T {
//
//        T withNewAssignee(string newAssigneeId);
//
//        string getWithNewAssignee();
//
//        T withLocalVariable(string variableName, Object variableValue);
//
//        T withLocalVariables(Map!(string, Object) variables);
//
//        Map!(string,Object) getActivityLocalVariables();
//    }
//
//    interface MultipleToActivityOptions<T : ActivityMigrationMapping> : ActivityMigrationMappingOptions!T {
//
//        T withLocalVariableForActivity(string toActivity, string variableName, Object variableValue);
//
//        T withLocalVariablesForActivity(string toActivity, Map!(string, Object) variables);
//
//        T withLocalVariableForAllActivities(string variableName, Object variableValue);
//
//        T withLocalVariablesForAllActivities(Map!(string, Object) variables);
//
//        T withLocalVariables(Map<string, Map!(string, Object)> mappingVariables);
//
//        Map<string, Map!(string, Object)> getActivitiesLocalVariables();
//    }
//
//}
