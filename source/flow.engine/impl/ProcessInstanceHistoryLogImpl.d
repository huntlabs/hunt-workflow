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


import hunt.collection.ArrayList;
import hunt.collection;
import hunt.collections;
import java.util.Comparator;
import hunt.time.LocalDateTime;
import hunt.collection.List;

import flow.common.api.history.HistoricData;
import flow.engine.history.HistoricProcessInstance;
import flow.engine.history.ProcessInstanceHistoryLog;

/**
 * @author Joram Barrez
 */
class ProcessInstanceHistoryLogImpl implements ProcessInstanceHistoryLog {

    protected HistoricProcessInstance historicProcessInstance;

    protected List!HistoricData historicData = new ArrayList<>();

    public ProcessInstanceHistoryLogImpl(HistoricProcessInstance historicProcessInstance) {
        this.historicProcessInstance = historicProcessInstance;
    }

    override
    public string getId() {
        return historicProcessInstance.getId();
    }

    override
    public string getBusinessKey() {
        return historicProcessInstance.getBusinessKey();
    }

    override
    public string getProcessDefinitionId() {
        return historicProcessInstance.getProcessDefinitionId();
    }

    override
    public Date getStartTime() {
        return historicProcessInstance.getStartTime();
    }

    override
    public Date getEndTime() {
        return historicProcessInstance.getEndTime();
    }

    override
    public Long getDurationInMillis() {
        return historicProcessInstance.getDurationInMillis();
    }

    override
    public string getStartUserId() {
        return historicProcessInstance.getStartUserId();
    }

    override
    public string getStartActivityId() {
        return historicProcessInstance.getStartActivityId();
    }

    override
    public string getDeleteReason() {
        return historicProcessInstance.getDeleteReason();
    }

    override
    public string getSuperProcessInstanceId() {
        return historicProcessInstance.getSuperProcessInstanceId();
    }

    override
    public string getTenantId() {
        return historicProcessInstance.getTenantId();
    }

    override
    public List!HistoricData getHistoricData() {
        return historicData;
    }

    public void addHistoricData(HistoricData historicEvent) {
        historicData.add(historicEvent);
    }

    public void addHistoricData(Collection<? : HistoricData> historicEvents) {
        historicData.addAll(historicEvents);
    }

    public void orderHistoricData() {
        Collections.sort(historicData, new Comparator!HistoricData() {
            override
            public int compare(HistoricData data1, HistoricData data2) {
                return data1.getTime().compareTo(data2.getTime());
            }
        });
    }

}
