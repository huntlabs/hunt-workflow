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
//import hunt.collection.List;
//
//import flow.engine.event.EventLogEntry;
//import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
//import flow.engine.impl.persistence.entity.data.EventLogEntryDataManager;
//
///**
// * @author Joram Barrez
// */
//class EventLogEntryEntityManagerImpl
//    extends AbstractProcessEngineEntityManager!(EventLogEntryEntity, EventLogEntryDataManager)
//    implements EventLogEntryEntityManager {
//
//    public EventLogEntryEntityManagerImpl(ProcessEngineConfigurationImpl processEngineConfiguration, EventLogEntryDataManager eventLogEntryDataManager) {
//        super(processEngineConfiguration, eventLogEntryDataManager);
//    }
//
//    override
//    public List!EventLogEntry findAllEventLogEntries() {
//        return dataManager.findAllEventLogEntries();
//    }
//
//    override
//    public List!EventLogEntry findEventLogEntries(long startLogNr, long pageSize) {
//        return dataManager.findEventLogEntries(startLogNr, pageSize);
//    }
//
//    override
//    public List!EventLogEntry findEventLogEntriesByProcessInstanceId(string processInstanceId) {
//        return dataManager.findEventLogEntriesByProcessInstanceId(processInstanceId);
//    }
//
//    override
//    public void deleteEventLogEntry(long logNr) {
//        dataManager.deleteEventLogEntry(logNr);
//    }
//
//}
