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
//import hunt.time.LocalDateTime;
//import hunt.collection.Map;
//
//import flow.common.api.deleg.event.FlowableEntityEvent;
//import flow.common.api.deleg.event.FlowableEvent;
//import flow.common.identity.Authentication;
//import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
//import flow.engine.impl.persistence.entity.EventLogEntryEntity;
//import flow.engine.impl.util.CommandContextUtil;
//import flow.engine.impl.util.ProcessDefinitionUtil;
//import flow.engine.repository.ProcessDefinition;
//import org.slf4j.Logger;
//import org.slf4j.LoggerFactory;
//
//import com.fasterxml.jackson.databind.ObjectMapper;
//
///**
// * @author Joram Barrez
// */
//abstract class AbstractDatabaseEventLoggerEventHandler implements EventLoggerEventHandler {
//
//    private static final Logger LOGGER = LoggerFactory.getLogger(AbstractDatabaseEventLoggerEventHandler.class);
//
//    protected FlowableEvent event;
//    protected Date timeStamp;
//    protected ObjectMapper objectMapper;
//
//    public AbstractDatabaseEventLoggerEventHandler() {
//    }
//
//    protected EventLogEntryEntity createEventLogEntry(Map!(string, Object) data) {
//        return createEventLogEntry(null, null, null, null, data);
//    }
//
//    protected EventLogEntryEntity createEventLogEntry(string processDefinitionId, string processInstanceId, string executionId, string taskId, Map!(string, Object) data) {
//        return createEventLogEntry(event.getType().name(), processDefinitionId, processInstanceId, executionId, taskId, data);
//    }
//
//    protected EventLogEntryEntity createEventLogEntry(string type, string processDefinitionId, string processInstanceId, string executionId, string taskId, Map!(string, Object) data) {
//
//        EventLogEntryEntity eventLogEntry = CommandContextUtil.getEventLogEntryEntityManager().create();
//        eventLogEntry.setProcessDefinitionId(processDefinitionId);
//        eventLogEntry.setProcessInstanceId(processInstanceId);
//        eventLogEntry.setExecutionId(executionId);
//        eventLogEntry.setTaskId(taskId);
//        eventLogEntry.setType(type);
//        eventLogEntry.setTimeStamp(timeStamp);
//        putInMapIfNotNull(data, Fields.TIMESTAMP, timeStamp);
//
//        // Current user
//        string userId = Authentication.getAuthenticatedUserId();
//        if (userId !is null) {
//            eventLogEntry.setUserId(userId);
//            putInMapIfNotNull(data, "userId", userId);
//        }
//
//        // Current tenant
//        if (!data.containsKey(Fields.TENANT_ID) && processDefinitionId !is null) {
//            ProcessDefinition processDefinition = ProcessDefinitionUtil.getProcessDefinition(processDefinitionId);
//            if (processDefinition !is null && !ProcessEngineConfigurationImpl.NO_TENANT_ID.equals(processDefinition.getTenantId())) {
//                putInMapIfNotNull(data, Fields.TENANT_ID, processDefinition.getTenantId());
//            }
//        }
//
//        try {
//            eventLogEntry.setData(objectMapper.writeValueAsBytes(data));
//        } catch (Exception e) {
//            LOGGER.warn("Could not serialize event data. Data will not be written to the database", e);
//        }
//
//        return eventLogEntry;
//
//    }
//
//    override
//    public void setEvent(FlowableEvent event) {
//        this.event = event;
//    }
//
//    override
//    public void setTimeStamp(Date timeStamp) {
//        this.timeStamp = timeStamp;
//    }
//
//    override
//    public void setObjectMapper(ObjectMapper objectMapper) {
//        this.objectMapper = objectMapper;
//    }
//
//    // Helper methods //////////////////////////////////////////////////////
//
//    @SuppressWarnings("unchecked")
//    public <T> T getEntityFromEvent() {
//        return (T) ((FlowableEntityEvent) event).getEntity();
//    }
//
//    public void putInMapIfNotNull(Map!(string, Object) map, string key, Object value) {
//        if (value !is null) {
//            map.put(key, value);
//        }
//    }
//
//}
