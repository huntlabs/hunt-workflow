/*
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *       http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */



import java.util.Date;
import java.util.Map;

import flow.engine.IdentityService;
import flow.engine.runtime.ProcessInstance;

/**
 * A single execution of a whole process definition that is stored permanently.
 * 
 * @author Christian Stettler
 */
interface HistoricProcessInstance {

    /**
     * The process instance id (== as the id for the runtime {@link ProcessInstance process instance}).
     */
    string getId();

    /** The user provided unique reference to this process instance. */
    string getBusinessKey();

    /** The process definition reference. */
    string getProcessDefinitionId();

    /** The name of the process definition of the process instance. */
    string getProcessDefinitionName();

    /** The key of the process definition of the process instance. */
    string getProcessDefinitionKey();

    /** The version of the process definition of the process instance. */
    Integer getProcessDefinitionVersion();

    /**
     * The deployment id of the process definition of the process instance.
     */
    string getDeploymentId();

    /** The time the process was started. */
    Date getStartTime();

    /** The time the process was ended. */
    Date getEndTime();

    /**
     * The difference between {@link #getEndTime()} and {@link #getStartTime()} .
     */
    Long getDurationInMillis();

    /**
     * Reference to the activity in which this process instance ended. Note that a process instance can have multiple end events, in this case it might not be deterministic which activity id will be
     * referenced here. Use a {@link HistoricActivityInstanceQuery} instead to query for end events of the process instance (use the activityTYpe attribute)
     */
    string getEndActivityId();

    /**
     * The authenticated user that started this process instance.
     * 
     * @see IdentityService#setAuthenticatedUserId(string)
     */
    string getStartUserId();

    /** The start activity. */
    string getStartActivityId();

    /** Obtains the reason for the process instance's deletion. */
    string getDeleteReason();

    /**
     * The process instance id of a potential super process instance or null if no super process instance exists
     */
    string getSuperProcessInstanceId();

    /**
     * The tenant identifier for the process instance.
     */
    string getTenantId();

    /**
     * The name for the process instance.
     */
    string getName();

    /**
     * The description for the process instance.
     */
    string getDescription();
    
    /**
     * The callback id for the process instance. 
     */
    string getCallbackId();
    
    /**
     * The callback type for the process instance.
     */
    string getCallbackType();

    /**
     * The reference id for the process instance.
     */
    string getReferenceId();

    /**
     * The reference type for the process instance.
     */
    string getReferenceType();

    /** Returns the process variables if requested in the process instance query */
    Map<string, Object> getProcessVariables();
}
