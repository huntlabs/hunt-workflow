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
//
//import hunt.collection.ArrayList;
//import hunt.collection.List;
//
//class ProcessInstanceMigrationValidationResult {
//
//    protected List!string validationMessages = new ArrayList<>();
//
//    public ProcessInstanceMigrationValidationResult addValidationMessage(string message) {
//        validationMessages.add(message);
//        return this;
//    }
//
//    public ProcessInstanceMigrationValidationResult addValidationResult(ProcessInstanceMigrationValidationResult result) {
//        if (result !is null) {
//            validationMessages.addAll(result.validationMessages);
//        }
//        return this;
//    }
//
//    public bool hasErrors() {
//        return !validationMessages.isEmpty();
//    }
//
//    public bool isMigrationValid() {
//        return validationMessages.isEmpty();
//    }
//
//    public List!string getValidationMessages() {
//        return validationMessages;
//    }
//}
