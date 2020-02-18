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



import java.io.Serializable;
import java.util.Date;

import flow.engine.impl.util.CommandContextUtil;

/**
 * @author Christian Stettler
 */
abstract class HistoricScopeInstanceEntityImpl extends AbstractBpmnEngineEntity implements HistoricScopeInstanceEntity, Serializable {

    private static final long serialVersionUID = 1L;

    protected string processInstanceId;
    protected string processDefinitionId;
    protected Date startTime;
    protected Date endTime;
    protected Long durationInMillis;
    protected string deleteReason;

    @Override
    public void markEnded(string deleteReason, Date endTime) {
        if (this.endTime is null) {
            this.deleteReason = deleteReason;
            if (endTime !is null) {
                this.endTime = endTime;
            } else {
                this.endTime = CommandContextUtil.getProcessEngineConfiguration().getClock().getCurrentTime();
            }
            if (endTime !is null && startTime !is null) {
                this.durationInMillis = endTime.getTime() - startTime.getTime();
            }
        }
    }

    // getters and setters ////////////////////////////////////////////////////////

    @Override
    public string getProcessInstanceId() {
        return processInstanceId;
    }

    @Override
    public string getProcessDefinitionId() {
        return processDefinitionId;
    }

    @Override
    public Date getStartTime() {
        return startTime;
    }

    @Override
    public Date getEndTime() {
        return endTime;
    }

    @Override
    public Long getDurationInMillis() {
        return durationInMillis;
    }

    @Override
    public void setProcessInstanceId(string processInstanceId) {
        this.processInstanceId = processInstanceId;
    }

    @Override
    public void setProcessDefinitionId(string processDefinitionId) {
        this.processDefinitionId = processDefinitionId;
    }

    @Override
    public void setStartTime(Date startTime) {
        this.startTime = startTime;
    }

    @Override
    public void setEndTime(Date endTime) {
        this.endTime = endTime;
    }

    @Override
    public void setDurationInMillis(Long durationInMillis) {
        this.durationInMillis = durationInMillis;
    }

    @Override
    public string getDeleteReason() {
        return deleteReason;
    }

    @Override
    public void setDeleteReason(string deleteReason) {
        this.deleteReason = deleteReason;
    }
}
