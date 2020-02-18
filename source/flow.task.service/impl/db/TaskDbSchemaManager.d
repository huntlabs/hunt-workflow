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


import flow.common.db.ServiceSqlScriptBasedDbSchemaManager;

/**
 * @author Joram Barrez
 */
class TaskDbSchemaManager extends ServiceSqlScriptBasedDbSchemaManager {

    private static final string TASK_TABLE = "ACT_RU_TASK";
    private static final string TASK_VERSION_PROPERTY = "task.schema.version";
    private static final string SCHEMA_COMPONENT = "task";
    private static final string SCHEMA_COMPONENT_HISTORY = "task.history";
    
    public TaskDbSchemaManager() {
        super(TASK_TABLE, SCHEMA_COMPONENT, SCHEMA_COMPONENT_HISTORY, TASK_VERSION_PROPERTY);
    }
    
    @Override
    protected string getResourcesRootDirectory() {
        return "org/flowable/task/service/db/";
    }

}
