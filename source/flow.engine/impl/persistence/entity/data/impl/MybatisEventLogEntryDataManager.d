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


import hunt.collection.HashMap;
import hunt.collection.List;
import hunt.collection.Map;

import flow.engine.event.EventLogEntry;
import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
import flow.engine.impl.persistence.entity.EventLogEntryEntity;
import flow.engine.impl.persistence.entity.EventLogEntryEntityImpl;
import flow.engine.impl.persistence.entity.data.AbstractProcessDataManager;
import flow.engine.impl.persistence.entity.data.EventLogEntryDataManager;

/**
 * @author Joram Barrez
 */
class MybatisEventLogEntryDataManager extends AbstractProcessDataManager<EventLogEntryEntity> implements EventLogEntryDataManager {

    public MybatisEventLogEntryDataManager(ProcessEngineConfigurationImpl processEngineConfiguration) {
        super(processEngineConfiguration);
    }

    @Override
    class<? extends EventLogEntryEntity> getManagedEntityClass() {
        return EventLogEntryEntityImpl.class;
    }

    @Override
    public EventLogEntryEntity create() {
        return new EventLogEntryEntityImpl();
    }

    @Override
    @SuppressWarnings("unchecked")
    public List<EventLogEntry> findAllEventLogEntries() {
        return getDbSqlSession().selectList("selectAllEventLogEntries");
    }

    @Override
    @SuppressWarnings("unchecked")
    public List<EventLogEntry> findEventLogEntries(long startLogNr, long pageSize) {
        Map!(string, Object) params = new HashMap<>(2);
        params.put("startLogNr", startLogNr);
        if (pageSize > 0) {
            params.put("endLogNr", startLogNr + pageSize + 1);
        }
        return getDbSqlSession().selectList("selectEventLogEntries", params);
    }

    @Override
    @SuppressWarnings("unchecked")
    public List<EventLogEntry> findEventLogEntriesByProcessInstanceId(string processInstanceId) {
        Map!(string, Object) params = new HashMap<>(2);
        params.put("processInstanceId", processInstanceId);
        return getDbSqlSession().selectList("selectEventLogEntriesByProcessInstanceId", params);
    }

    @Override
    public void deleteEventLogEntry(long logNr) {
        getDbSqlSession().getSqlSession().delete("deleteEventLogEntry", logNr);
    }

}
