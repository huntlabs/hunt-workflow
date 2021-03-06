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

module flow.engine.ProcessEngine;





import flow.common.api.Engine;
import flow.common.FlowableVersions;
import flow.engine.RepositoryService;
import flow.engine.RuntimeService;
import flow.engine.FormService;
import flow.engine.TaskService;
import flow.engine.HistoryService;
import flow.engine.IdentityService;
import flow.engine.ManagementService;
//import flow.engine.DynamicBpmnService;
//import flow.engine.ProcessMigrationService;
import flow.engine.ProcessEngineConfiguration;

/**
 * Provides access to all the services that expose the BPM and workflow operations.
 *
 * <ul>
 * <li><b>{@link flow.engine.RuntimeService}: </b> Allows the creation of {@link flow.engine.repository.Deployment}s and the starting of and searching on
 * {@link flow.engine.runtime.ProcessInstance}s.</li>
 * <li><b>{@link flow.engine.TaskService}: </b> Exposes operations to manage human (standalone) {@link flow.task.api.Task}s, such as claiming, completing and assigning tasks</li>
 * <li><b>{@link flow.engine.IdentityService}: </b> Used for managing {@link flow.idm.api.User}s, {@link flow.idm.api.Group}s and the relations between them<</li>
 * <li><b>{@link flow.engine.ManagementService}: </b> Exposes engine admin and maintenance operations</li>
 * <li><b>{@link flow.engine.HistoryService}: </b> Service exposing information about ongoing and past process instances.</li>
 * </ul>
 *
 * Typically, there will be only one central ProcessEngine instance needed in a end-user application. Building a ProcessEngine is done through a {@link ProcessEngineConfiguration} instance and is a
 * costly operation which should be avoided. For that purpose, it is advised to store it in a static field or JNDI location (or something similar). This is a thread-safe object, so no special
 * precautions need to be taken.
 *
 * @author Tom Baeyens
 * @author Joram Barrez
 */
interface ProcessEngine : Engine {

    /** the version of the flowable library */
    public static string VERSION = "6.5.0.6";

    /**
     * Starts the execuctors (async and async history), if they are configured to be auto-actived.
     */
    void startExecutors();

    RepositoryService getRepositoryService();

    RuntimeService getRuntimeService();

    FormService getFormService();

    TaskService getTaskService();

    HistoryService getHistoryService();

    IdentityService getIdentityService();

    ManagementService getManagementService();

    //DynamicBpmnService getDynamicBpmnService();
    //
    //ProcessMigrationService getProcessMigrationService();

    ProcessEngineConfiguration getProcessEngineConfiguration();
}
