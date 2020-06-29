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
module flow.engine.impl.ProcessInstanceHistoryLogImpl;

import hunt.collection.ArrayList;
import hunt.collection;
import hunt.collection.Collections;
import hunt.util.Comparator;
import hunt.time.LocalDateTime;
import hunt.collection.List;
import hunt.Exceptions;
import flow.common.api.history.HistoricData;
import flow.engine.history.HistoricProcessInstance;
import flow.engine.history.ProcessInstanceHistoryLog;

/**
 * @author Joram Barrez
 */
class ProcessInstanceHistoryLogImpl : ProcessInstanceHistoryLog {

    protected HistoricProcessInstance historicProcessInstance;

    protected List!HistoricData historicData ;// = new ArrayList<>();

    this(HistoricProcessInstance historicProcessInstance) {
        this.historicProcessInstance = historicProcessInstance;
        historicData = new ArrayList!HistoricData;
    }


    public string getId() {
        return historicProcessInstance.getId();
    }


    public string getBusinessKey() {
        return historicProcessInstance.getBusinessKey();
    }


    public string getProcessDefinitionId() {
        return historicProcessInstance.getProcessDefinitionId();
    }


    public Date getStartTime() {
        return historicProcessInstance.getStartTime();
    }


    public Date getEndTime() {
        return historicProcessInstance.getEndTime();
    }


    public long getDurationInMillis() {
        return historicProcessInstance.getDurationInMillis();
    }


    public string getStartUserId() {
        return historicProcessInstance.getStartUserId();
    }


    public string getStartActivityId() {
        return historicProcessInstance.getStartActivityId();
    }


    public string getDeleteReason() {
        return historicProcessInstance.getDeleteReason();
    }


    public string getSuperProcessInstanceId() {
        return historicProcessInstance.getSuperProcessInstanceId();
    }


    public string getTenantId() {
        return historicProcessInstance.getTenantId();
    }


    public List!HistoricData getHistoricData() {
        return historicData;
    }

    public void addHistoricData(HistoricData historicEvent) {
        historicData.add(historicEvent);
    }

    public void addHistoricData(Collection!HistoricData historicEvents) {
        historicData.addAll(historicEvents);
    }

    public void orderHistoricData() {
          implementationMissing(false);
        //historicData.sort(new class Comparator!HistoricData {
        //    public int compare(HistoricData data1, HistoricData data2) {
        //        return cast(int)(data1.getTime().toEpochMilli - data2.getTime().toEpochMilli);
        //    }
        //});
    }

}
