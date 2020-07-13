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
module flow.variable.service.impl.HistoricVariableServiceImpl;

import hunt.time.LocalDateTime;
import hunt.collection.List;

import flow.common.context.Context;
//import flow.common.persistence.cache.EntityCache;
import flow.common.service.CommonServiceImpl;
import flow.variable.service.api.history.HistoricVariableInstance;
import flow.variable.service.HistoricVariableService;
import flow.variable.service.VariableServiceConfiguration;
import flow.variable.service.impl.persistence.entity.HistoricVariableInstanceEntity;
import flow.variable.service.impl.persistence.entity.HistoricVariableInstanceEntityManager;
import flow.variable.service.impl.persistence.entity.VariableInstanceEntity;
import flow.variable.service.impl.HistoricVariableInstanceQueryImpl;

/**
 * @author Tom Baeyens
 * @author Joram Barrez
 */
class HistoricVariableServiceImpl : CommonServiceImpl!VariableServiceConfiguration , HistoricVariableService {

    this(VariableServiceConfiguration variableServiceConfiguration) {
        super(variableServiceConfiguration);
    }


    public HistoricVariableInstanceEntity getHistoricVariableInstance(string id) {
        return getHistoricVariableInstanceEntityManager().findById(id);
    }


    public List!HistoricVariableInstance findHistoricVariableInstancesByQueryCriteria(HistoricVariableInstanceQueryImpl query) {
        return getHistoricVariableInstanceEntityManager().findHistoricVariableInstancesByQueryCriteria(query);
    }


    public HistoricVariableInstanceEntity createHistoricVariableInstance() {
        return getHistoricVariableInstanceEntityManager().create();
    }


    public void insertHistoricVariableInstance(HistoricVariableInstanceEntity variable) {
        getHistoricVariableInstanceEntityManager().insert(variable);
    }


    public HistoricVariableInstanceEntity createAndInsert(VariableInstanceEntity variable, Date createTime) {
        return getHistoricVariableInstanceEntityManager().createAndInsert(variable, createTime);
    }


    public void recordVariableUpdate(VariableInstanceEntity variableInstanceEntity, Date updateTime) {
        HistoricVariableInstanceEntity historicVariable = null ;//= getEntityCache().findInCache(HistoricVariableInstanceEntity.class, variableInstanceEntity.getId());
        HistoricVariableInstanceEntityManager historicVariableInstanceEntityManager = getHistoricVariableInstanceEntityManager();
        if (historicVariable is null) {
          historicVariable = historicVariableInstanceEntityManager.findById(variableInstanceEntity.getId());
        }

        if (historicVariable !is null) {
          historicVariableInstanceEntityManager.copyVariableValue(historicVariable, variableInstanceEntity, updateTime);
        } else {
          historicVariableInstanceEntityManager.createAndInsert(variableInstanceEntity, updateTime);
        }
        //HistoricVariableInstanceEntity historicVariable = getEntityCache().findInCache(HistoricVariableInstanceEntity.class, variableInstanceEntity.getId());
        //HistoricVariableInstanceEntityManager historicVariableInstanceEntityManager = getHistoricVariableInstanceEntityManager();
        //if (historicVariable is null) {
        //    historicVariable = historicVariableInstanceEntityManager.findById(variableInstanceEntity.getId());
        //}
        //
        //if (historicVariable !is null) {
        //    historicVariableInstanceEntityManager.copyVariableValue(historicVariable, variableInstanceEntity, updateTime);
        //} else {
        //    historicVariableInstanceEntityManager.createAndInsert(variableInstanceEntity, updateTime);
        //}
    }


    public void recordVariableRemoved(VariableInstanceEntity variableInstanceEntity) {
        HistoricVariableInstanceEntity historicProcessVariable  = null ;//= getEntityCache().findInCache(HistoricVariableInstanceEntity.class, variableInstanceEntity.getId());
        HistoricVariableInstanceEntityManager historicVariableInstanceEntityManager = getHistoricVariableInstanceEntityManager();
        if (historicProcessVariable is null) {
            historicProcessVariable = historicVariableInstanceEntityManager.findById(variableInstanceEntity.getId());
        }

        if (historicProcessVariable !is null) {
            getHistoricVariableInstanceEntityManager().dele(historicProcessVariable);
        }
    }

    //protected EntityCache getEntityCache() {
    //    return Context.getCommandContext().getSession(EntityCache.class);
    //}


    public void deleteHistoricVariableInstance(HistoricVariableInstanceEntity historicVariable) {
        getHistoricVariableInstanceEntityManager().dele(historicVariable);
    }


    public void deleteHistoricVariableInstancesByProcessInstanceId(string processInstanceId) {
        getHistoricVariableInstanceEntityManager().deleteHistoricVariableInstanceByProcessInstanceId(processInstanceId);
    }


    public void deleteHistoricVariableInstancesByTaskId(string taskId) {
        getHistoricVariableInstanceEntityManager().deleteHistoricVariableInstancesByTaskId(taskId);
    }


    public void deleteHistoricVariableInstancesForNonExistingProcessInstances() {
        getHistoricVariableInstanceEntityManager().deleteHistoricVariableInstancesForNonExistingProcessInstances();
    }


    public void deleteHistoricVariableInstancesForNonExistingCaseInstances() {
        getHistoricVariableInstanceEntityManager().deleteHistoricVariableInstancesForNonExistingCaseInstances();
    }

    public HistoricVariableInstanceEntityManager getHistoricVariableInstanceEntityManager() {
        return configuration.getHistoricVariableInstanceEntityManager();
    }
}
