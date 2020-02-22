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



import static flow.engine.impl.util.CommandContextUtil.getEntityCache;

import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.Objects;

import org.flowable.bpmn.model.FlowElement;
import org.flowable.bpmn.model.FlowNode;
import org.flowable.bpmn.model.SequenceFlow;
import flow.common.cfg.IdGenerator;
import flow.engine.history.HistoricActivityInstance;
import flow.engine.impl.ActivityInstanceQueryImpl;
import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
import flow.engine.impl.history.HistoryManager;
import flow.engine.impl.persistence.entity.data.ActivityInstanceDataManager;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.runtime.ActivityInstance;
import org.flowable.task.service.impl.persistence.entity.TaskEntity;

/**
 * @author martin.grofcik
 */
class ActivityInstanceEntityManagerImpl
    extends AbstractProcessEngineEntityManager<ActivityInstanceEntity, ActivityInstanceDataManager>
    implements ActivityInstanceEntityManager {

    protected static final string NO_ACTIVITY_ID_PREFIX = "_flow_";
    protected static final string NO_ACTIVITY_ID_SEPARATOR = "__";

    protected final bool usePrefixId;

    public ActivityInstanceEntityManagerImpl(ProcessEngineConfigurationImpl processEngineConfiguration, ActivityInstanceDataManager activityInstanceDataManager) {
        super(processEngineConfiguration, activityInstanceDataManager);
        this.usePrefixId = processEngineConfiguration.isUsePrefixId();
    }

    protected List<ActivityInstanceEntity> findUnfinishedActivityInstancesByExecutionAndActivityId(string executionId, string activityId) {
        return dataManager.findUnfinishedActivityInstancesByExecutionAndActivityId(executionId, activityId);
    }
    
    @Override
    public List<ActivityInstanceEntity> findActivityInstancesByExecutionAndActivityId(string executionId, string activityId) {
        return dataManager.findActivityInstancesByExecutionIdAndActivityId(executionId, activityId);
    }

    @Override
    public void deleteActivityInstancesByProcessInstanceId(string processInstanceId) {
        dataManager.deleteActivityInstancesByProcessInstanceId(processInstanceId);
    }

    @Override
    public long findActivityInstanceCountByQueryCriteria(ActivityInstanceQueryImpl historicActivityInstanceQuery) {
        return dataManager.findActivityInstanceCountByQueryCriteria(historicActivityInstanceQuery);
    }

    @Override
    public List<ActivityInstance> findActivityInstancesByQueryCriteria(ActivityInstanceQueryImpl historicActivityInstanceQuery) {
        return dataManager.findActivityInstancesByQueryCriteria(historicActivityInstanceQuery);
    }

    @Override
    public List<ActivityInstance> findActivityInstancesByNativeQuery(Map<string, Object> parameterMap) {
        return dataManager.findActivityInstancesByNativeQuery(parameterMap);
    }

    @Override
    public long findActivityInstanceCountByNativeQuery(Map<string, Object> parameterMap) {
        return dataManager.findActivityInstanceCountByNativeQuery(parameterMap);
    }

    @Override
    public void recordActivityStart(ExecutionEntity executionEntity) {
        ActivityInstance activityInstance = recordRuntimeActivityStart(executionEntity);
        if (activityInstance !is null) {
            getHistoryManager().recordActivityStart(activityInstance);
        }
    }

    @Override
    public void recordActivityEnd(ExecutionEntity executionEntity, string deleteReason) {
        ActivityInstance activityInstance = recordActivityInstanceEnd(executionEntity, deleteReason);
        if (activityInstance is null) {
            getHistoryManager().recordActivityEnd(executionEntity, deleteReason, getClock().getCurrentTime());
        } else {
            getHistoryManager().recordActivityEnd(activityInstance);
        }
    }

    @Override
    public void recordSequenceFlowTaken(ExecutionEntity executionEntity) {
        ActivityInstanceEntity activityInstance = createActivityInstanceEntity(executionEntity);
        activityInstance.setDurationInMillis(0l);
        activityInstance.setEndTime(activityInstance.getStartTime());
        getHistoryManager().createHistoricActivityInstance(activityInstance);
    }

    @Override
    public void recordSubProcessInstanceStart(ExecutionEntity parentExecution, ExecutionEntity subProcessInstance) {
        ActivityInstanceEntity activityInstance = findUnfinishedActivityInstance(parentExecution);
        if (activityInstance !is null) {
            activityInstance.setCalledProcessInstanceId(subProcessInstance.getProcessInstanceId());
            getHistoryManager().updateHistoricActivityInstance(activityInstance);
        }

        getHistoryManager().recordProcessInstanceStart(subProcessInstance);
    }

    @Override
    public void recordTaskCreated(TaskEntity task, ExecutionEntity execution) {
        recordActivityTaskCreated(task, execution);
        getHistoryManager().recordTaskCreated(task, execution);
    }

    protected void recordActivityTaskCreated(TaskEntity task, ExecutionEntity execution) {
        if (execution !is null) {
            ActivityInstanceEntity activityInstance = findUnfinishedActivityInstance(execution);
            if (activityInstance !is null) {
                activityInstance.setTaskId(task.getId());
                getHistoryManager().updateHistoricActivityInstance(activityInstance);
            }
        }
    }

    @Override
    public void recordTaskInfoChange(TaskEntity taskEntity, Date changeTime) {
        ActivityInstanceEntity activityInstanceEntity = recordActivityTaskInfoChange(taskEntity);
        getHistoryManager().recordTaskInfoChange(taskEntity, activityInstanceEntity !is null ? activityInstanceEntity.getId() : null, changeTime);
    }

    @Override
    public void syncUserTaskExecution(ExecutionEntity executionEntity, FlowElement newFlowElement, string oldActivityId, TaskEntity task) {
        syncUserTaskExecutionActivityInstance(executionEntity, oldActivityId, newFlowElement);
        getHistoryManager().updateActivity(executionEntity, oldActivityId, newFlowElement, task, getClock().getCurrentTime());
    }

    @Override
    public void updateActivityInstancesProcessDefinitionId(string newProcessDefinitionId, string processInstanceId) {
        ActivityInstanceQueryImpl activityQuery = new ActivityInstanceQueryImpl();
        activityQuery.processInstanceId(processInstanceId);
        List<ActivityInstance> activities = findActivityInstancesByQueryCriteria(activityQuery);
        if (activities !is null) {
            for (ActivityInstance activityInstance : activities) {
                ActivityInstanceEntity activityEntity = (ActivityInstanceEntity) activityInstance;
                activityEntity.setProcessDefinitionId(newProcessDefinitionId);
                update(activityEntity);
            }
        }
    }

    protected void syncUserTaskExecutionActivityInstance(ExecutionEntity childExecution, string oldActivityId,
        FlowElement newFlowElement) {
        ActivityInstanceEntityManager activityInstanceEntityManager = CommandContextUtil.getActivityInstanceEntityManager();
        List<ActivityInstanceEntity> activityInstances = activityInstanceEntityManager.findActivityInstancesByExecutionAndActivityId(childExecution.getId(), oldActivityId);
        for (ActivityInstanceEntity activityInstance : activityInstances) {
            activityInstance.setProcessDefinitionId(childExecution.getProcessDefinitionId());
            activityInstance.setActivityId(childExecution.getActivityId());
            activityInstance.setActivityName(newFlowElement.getName());
        }
    }

    protected ActivityInstanceEntity recordActivityTaskInfoChange(TaskEntity taskEntity) {
        ActivityInstanceEntity activityInstance = null;
        ExecutionEntity executionEntity = getExecutionEntityManager().findById(taskEntity.getExecutionId());
        if (executionEntity !is null) {
            if (!Objects.equals(getOriginalAssignee(taskEntity), taskEntity.getAssignee())) {
                activityInstance = findUnfinishedActivityInstance(executionEntity);
                if (activityInstance is null) {
                    HistoricActivityInstanceEntity historicActivityInstance = getHistoryManager().findHistoricActivityInstance(executionEntity, true);
                    if (historicActivityInstance !is null) {
                        activityInstance = createActivityInstance(historicActivityInstance);
                    }
                }
                if (activityInstance !is null) {
                    activityInstance.setAssignee(taskEntity.getAssignee());
                    getHistoryManager().updateHistoricActivityInstance(activityInstance);
                }
            }
        }

        return activityInstance;
    }

    @SuppressWarnings("unchecked")
    protected Object getOriginalAssignee(TaskEntity taskEntity) {
        if (taskEntity.getOriginalPersistentState() !is null) {
            return ((Map<string, Object>) taskEntity.getOriginalPersistentState()).get("assignee");
        } else {
            return null;
        }
    }

    protected ActivityInstance recordRuntimeActivityStart(ExecutionEntity executionEntity) {
        ActivityInstance activityInstance = null;
        if (executionEntity.getActivityId() !is null && executionEntity.getCurrentFlowElement() !is null) {
            activityInstance = findUnfinishedActivityInstance(executionEntity);
            if (activityInstance is null) {
                return createActivityInstance(executionEntity);
            }
        }

        return null;
    }

    protected ActivityInstance createActivityInstance(ExecutionEntity executionEntity) {
        ActivityInstance activityInstance = null;
        if (executionEntity.getActivityId() !is null && executionEntity.getCurrentFlowElement() !is null) {

            // activity instance could have been created (but only in cache, never persisted)
            // for example when submitting form properties
            activityInstance = getActivityInstanceFromCache(executionEntity.getId(), executionEntity.getActivityId(), true);
            if (activityInstance  is null) {
                activityInstance = createActivityInstanceEntity(executionEntity);
            } else {
                // activityInstance is not null only on its creation time
                activityInstance = null;
            }
        }
        return activityInstance;
    }

    protected ActivityInstance recordActivityInstanceEnd(ExecutionEntity executionEntity, string deleteReason) {
        ActivityInstanceEntity activityInstance = findUnfinishedActivityInstance(executionEntity);
        if (activityInstance !is null) {
            activityInstance.markEnded(deleteReason);
        } else {
            // in the case of upgrade from 6.4.1.1 to 6.4.1.2 we have to create activityInstance for all already unfinished historicActivities
            // which are going to be ended
            HistoricActivityInstanceEntity historicActivityInstance = getHistoryManager().findHistoricActivityInstance(executionEntity, true);
            if (historicActivityInstance !is null) {
                activityInstance = createActivityInstance(historicActivityInstance);
                activityInstance.markEnded(deleteReason);
            }
        }
        return activityInstance;
    }

    @Override
    public ActivityInstanceEntity findUnfinishedActivityInstance(ExecutionEntity execution) {
        string activityId = getActivityIdForExecution(execution);
        if (activityId !is null) {
            // No use looking for the ActivityInstance when no activityId is provided.

            string executionId = execution.getId();

            // Check the cache
            ActivityInstanceEntity activityInstanceFromCache = getActivityInstanceFromCache(executionId, activityId, true);
            if (activityInstanceFromCache !is null) {
                return activityInstanceFromCache;
            }

            // If the execution was freshly created, there is no need to check the database,
            // there can never be an entry for a activity instance with this execution id.
            if (!execution.isInserted() && !execution.isProcessInstanceType()) {

                // Check the database
                List<ActivityInstanceEntity> activityInstances = findUnfinishedActivityInstancesByExecutionAndActivityId(executionId, activityId);
                // cache can be updated before DB
                ActivityInstanceEntity activityFromCache = getActivityInstanceFromCache(executionId, activityId, false);
                if (activityFromCache !is null && activityFromCache.getEndTime() !is null) {
                    activityInstances.remove(activityFromCache);
                }
                if (activityInstances.size() > 0) {
                    return activityInstances.get(0);
                }

            }
        }

        return null;
    }

    protected ActivityInstanceEntity createActivityInstanceEntity(ExecutionEntity execution) {
        IdGenerator idGenerator = engineConfiguration.getIdGenerator();

        string processDefinitionId = execution.getProcessDefinitionId();
        string processInstanceId = execution.getProcessInstanceId();

        ActivityInstanceEntity activityInstanceEntity = create();
        if (usePrefixId) {
            activityInstanceEntity.setId(activityInstanceEntity.getIdPrefix() + idGenerator.getNextId());
        } else {
            activityInstanceEntity.setId(idGenerator.getNextId());
        }

        activityInstanceEntity.setProcessDefinitionId(processDefinitionId);
        activityInstanceEntity.setProcessInstanceId(processInstanceId);
        activityInstanceEntity.setExecutionId(execution.getId());
        if (execution.getActivityId() !is null ) {
            activityInstanceEntity.setActivityId(execution.getActivityId());
        } else {
            // sequence flow activity id can be null
            if (execution.getCurrentFlowElement() instanceof SequenceFlow) {
                SequenceFlow currentFlowElement = (SequenceFlow) execution.getCurrentFlowElement();
                activityInstanceEntity.setActivityId(getArtificialSequenceFlowId(currentFlowElement));
            }
        }

        if (execution.getCurrentFlowElement() !is null) {
            activityInstanceEntity.setActivityName(execution.getCurrentFlowElement().getName());
            activityInstanceEntity.setActivityType(parseActivityType(execution.getCurrentFlowElement()));
        }
        Date now = getClock().getCurrentTime();
        activityInstanceEntity.setStartTime(now);

        if (execution.getTenantId() !is null) {
            activityInstanceEntity.setTenantId(execution.getTenantId());
        }

        insert(activityInstanceEntity);
        return activityInstanceEntity;
    }

    protected ActivityInstanceEntity getActivityInstanceFromCache(string executionId, string activityId, bool endTimeMustBeNull) {
        List<ActivityInstanceEntity> cachedActivityInstances = getEntityCache().findInCache(ActivityInstanceEntity.class);
        for (ActivityInstanceEntity cachedActivityInstance : cachedActivityInstances) {
            if (activityId !is null
                && activityId.equals(cachedActivityInstance.getActivityId())
                && (!endTimeMustBeNull || cachedActivityInstance.getEndTime() is null)) {
                if (executionId.equals(cachedActivityInstance.getExecutionId())) {
                    return cachedActivityInstance;
                }
            }
        }

        return null;
    }

    protected string parseActivityType(FlowElement element) {
        string elementType = element.getClass().getSimpleName();
        elementType = elementType.substring(0, 1).toLowerCase() + elementType.substring(1);
        return elementType;
    }

    protected string getActivityIdForExecution(ExecutionEntity execution) {
        string activityId = null;
        if (execution.getCurrentFlowElement() instanceof FlowNode) {
            activityId = execution.getCurrentFlowElement().getId();
        } else if (execution.getCurrentFlowElement() instanceof SequenceFlow
            && execution.getCurrentFlowableListener() is null) { // while executing sequence flow listeners, we don't want historic activities
            activityId = ((SequenceFlow) execution.getCurrentFlowElement()).getSourceFlowElement().getId();
        }
        return activityId;
    }

    protected ActivityInstanceEntity createActivityInstance(HistoricActivityInstance historicActivityInstance) {
        ActivityInstanceEntity activityInstanceEntity = create();
        activityInstanceEntity.setId(historicActivityInstance.getId());

        activityInstanceEntity.setProcessDefinitionId(historicActivityInstance.getProcessDefinitionId());
        activityInstanceEntity.setProcessInstanceId(historicActivityInstance.getProcessInstanceId());
        activityInstanceEntity.setCalledProcessInstanceId(historicActivityInstance.getCalledProcessInstanceId());
        activityInstanceEntity.setExecutionId(historicActivityInstance.getExecutionId());
        activityInstanceEntity.setTaskId(historicActivityInstance.getTaskId());
        activityInstanceEntity.setActivityId(historicActivityInstance.getActivityId());
        activityInstanceEntity.setActivityName(historicActivityInstance.getActivityName());
        activityInstanceEntity.setActivityType(historicActivityInstance.getActivityType());
        activityInstanceEntity.setAssignee(historicActivityInstance.getAssignee());
        activityInstanceEntity.setStartTime(historicActivityInstance.getStartTime());
        activityInstanceEntity.setEndTime(historicActivityInstance.getEndTime());
        activityInstanceEntity.setDeleteReason(historicActivityInstance.getDeleteReason());
        activityInstanceEntity.setDurationInMillis(historicActivityInstance.getDurationInMillis());
        activityInstanceEntity.setTenantId(historicActivityInstance.getTenantId());

        insert(activityInstanceEntity);
        return activityInstanceEntity;
    }

    protected string getArtificialSequenceFlowId(SequenceFlow sequenceFlow) {
        return NO_ACTIVITY_ID_PREFIX + sequenceFlow.getSourceRef() + NO_ACTIVITY_ID_SEPARATOR + sequenceFlow.getTargetRef();
    }

    protected HistoryManager getHistoryManager() {
        return engineConfiguration.getHistoryManager();
    }

    protected ExecutionEntityManager getExecutionEntityManager() {
        return engineConfiguration.getExecutionEntityManager();
    }

}