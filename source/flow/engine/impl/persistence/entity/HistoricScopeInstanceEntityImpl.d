///*
// * Licensed under the Apache License, Version 2.0 (the "License");
// * you may not use this file except in compliance with the License.
// * You may obtain a copy of the License at
// *
// *       http://www.apache.org/licenses/LICENSE-2.0
// *
// * Unless required by applicable law or agreed to in writing, software
// * distributed under the License is distributed on an "AS IS" BASIS,
// * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// * See the License for the specific language governing permissions and
// * limitations under the License.
// */
//
//module flow.engine.impl.persistence.entity.HistoricScopeInstanceEntityImpl;
//
//import hunt.time.LocalDateTime;
//
//import flow.engine.impl.util.CommandContextUtil;
//import hunt.time.LocalDateTime;
//import flow.engine.impl.persistence.entity.AbstractBpmnEngineEntity;
//import flow.engine.impl.persistence.entity.HistoricScopeInstanceEntity;
//import hunt.entity;
//
//alias Date = LocalDateTime;
//
//
///**
// * @author Christian Stettler
// */
//abstract class HistoricScopeInstanceEntityImpl : AbstractBpmnEngineEntity , HistoricScopeInstanceEntity {
//
//    protected string processInstanceId;
//    protected string processDefinitionId;
//    protected Date startTime;
//    protected Date endTime;
//    protected long durationInMillis;
//    protected string deleteReason;
//
//    public void markEnded(string deleteReason, Date endTime) {
//        if (this.endTime is null) {
//            this.deleteReason = deleteReason;
//            if (endTime !is null) {
//                this.endTime = endTime;
//            } else {
//                this.endTime = CommandContextUtil.getProcessEngineConfiguration().getClock().getCurrentTime();
//            }
//            if (endTime !is null && startTime !is null) {
//                this.durationInMillis = endTime.getTime() - startTime.getTime();
//            }
//        }
//    }
//
//    // getters and setters ////////////////////////////////////////////////////////
//
//    override
//    public string getProcessInstanceId() {
//        return processInstanceId;
//    }
//
//    override
//    public string getProcessDefinitionId() {
//        return processDefinitionId;
//    }
//
//    override
//    public Date getStartTime() {
//        return startTime;
//    }
//
//    override
//    public Date getEndTime() {
//        return endTime;
//    }
//
//    override
//    public Long getDurationInMillis() {
//        return durationInMillis;
//    }
//
//    override
//    public void setProcessInstanceId(string processInstanceId) {
//        this.processInstanceId = processInstanceId;
//    }
//
//    override
//    public void setProcessDefinitionId(string processDefinitionId) {
//        this.processDefinitionId = processDefinitionId;
//    }
//
//    override
//    public void setStartTime(Date startTime) {
//        this.startTime = startTime;
//    }
//
//    override
//    public void setEndTime(Date endTime) {
//        this.endTime = endTime;
//    }
//
//    override
//    public void setDurationInMillis(Long durationInMillis) {
//        this.durationInMillis = durationInMillis;
//    }
//
//    override
//    public string getDeleteReason() {
//        return deleteReason;
//    }
//
//    override
//    public void setDeleteReason(string deleteReason) {
//        this.deleteReason = deleteReason;
//    }
//}
