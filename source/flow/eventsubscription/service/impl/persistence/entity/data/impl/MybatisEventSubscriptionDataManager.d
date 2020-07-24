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
module flow.eventsubscription.service.impl.persistence.entity.data.impl.MybatisEventSubscriptionDataManager;

import hunt.logging;
import hunt.collection.ArrayList;
import hunt.collection.HashMap;
import hunt.collection.List;
import hunt.collection.Map;

//import flow.common.db.DbSqlSession;
//import flow.common.persistence.cache.CachedEntityMatcher;
import flow.eventsubscription.service.api.EventSubscription;
import flow.eventsubscription.service.EventSubscriptionServiceConfiguration;
import flow.eventsubscription.service.impl.EventSubscriptionQueryImpl;
import flow.eventsubscription.service.impl.persistence.entity.CompensateEventSubscriptionEntity;
import flow.eventsubscription.service.impl.persistence.entity.CompensateEventSubscriptionEntityImpl;
import flow.eventsubscription.service.impl.persistence.entity.EventSubscriptionEntity;
import flow.eventsubscription.service.impl.persistence.entity.EventSubscriptionEntityImpl;
import flow.eventsubscription.service.impl.persistence.entity.GenericEventSubscriptionEntity;
import flow.eventsubscription.service.impl.persistence.entity.GenericEventSubscriptionEntityImpl;
import flow.eventsubscription.service.impl.persistence.entity.MessageEventSubscriptionEntity;
import flow.eventsubscription.service.impl.persistence.entity.MessageEventSubscriptionEntityImpl;
import flow.eventsubscription.service.impl.persistence.entity.SignalEventSubscriptionEntity;
import flow.eventsubscription.service.impl.persistence.entity.SignalEventSubscriptionEntityImpl;
import flow.eventsubscription.service.impl.persistence.entity.data.AbstractEventSubscriptionDataManager;
import flow.eventsubscription.service.impl.persistence.entity.data.EventSubscriptionDataManager;
import hunt.Exceptions;
import hunt.entity;
import flow.common.AbstractEngineConfiguration;
//import flow.eventsubscription.service.impl.persistence.entity.data.impl.cachematcher.EventSubscriptionsByExecutionAndTypeMatcher;
//import flow.eventsubscription.service.impl.persistence.entity.data.impl.cachematcher.EventSubscriptionsByExecutionIdMatcher;
//import flow.eventsubscription.service.impl.persistence.entity.data.impl.cachematcher.EventSubscriptionsByNameMatcher;
//import flow.eventsubscription.service.impl.persistence.entity.data.impl.cachematcher.EventSubscriptionsByProcInstTypeAndActivityMatcher;
//import flow.eventsubscription.service.impl.persistence.entity.data.impl.cachematcher.EventSubscriptionsByScopeDefinitionIdAndTypeMatcher;
//import flow.eventsubscription.service.impl.persistence.entity.data.impl.cachematcher.EventSubscriptionsBySubScopeIdMatcher;
//import flow.eventsubscription.service.impl.persistence.entity.data.impl.cachematcher.MessageEventSubscriptionsByProcInstAndEventNameMatcher;
//import flow.eventsubscription.service.impl.persistence.entity.data.impl.cachematcher.SignalEventSubscriptionByEventNameMatcher;
//import flow.eventsubscription.service.impl.persistence.entity.data.impl.cachematcher.SignalEventSubscriptionByNameAndExecutionMatcher;
//import flow.eventsubscription.service.impl.persistence.entity.data.impl.cachematcher.SignalEventSubscriptionByProcInstAndEventNameMatcher;
//import flow.eventsubscription.service.impl.persistence.entity.data.impl.cachematcher.SignalEventSubscriptionByScopeAndEventNameMatcher;
//import flow.eventsubscription.service.impl.persistence.entity.data.impl.cachematcher.SignalEventSubscriptionByScopeIdAndTypeMatcher;

/**
 * @author Joram Barrez
 */
class MybatisEventSubscriptionDataManager : EntityRepository!(EventSubscriptionEntityImpl , string) , EventSubscriptionDataManager {

    private EventSubscriptionServiceConfiguration eventSubscriptionServiceConfiguration;

    alias insert = CrudRepository!(EventSubscriptionEntityImpl , string).insert;
    alias findById = CrudRepository!(EventSubscriptionEntityImpl , string).findById;
    alias update = CrudRepository!(EventSubscriptionEntityImpl , string).update;
    //this(EventSubscriptionServiceConfiguration eventSubscriptionServiceConfiguration) {
    //  this.eventSubscriptionServiceConfiguration = eventSubscriptionServiceConfiguration;
    //}
    //
    //public EventSubscriptionServiceConfiguration getEventSubscriptionServiceConfiguration() {
    //  return eventSubscriptionServiceConfiguration;
    //}

    public void setEventSubscriptionServiceConfiguration(EventSubscriptionServiceConfiguration eventSubscriptionServiceConfiguration) {
      this.eventSubscriptionServiceConfiguration = eventSubscriptionServiceConfiguration;
    }
//class MybatisEventSubscriptionDataManager : AbstractEventSubscriptionDataManager!EventSubscriptionEntity , EventSubscriptionDataManager {
    //private static List<Class<? extends EventSubscriptionEntity>> ENTITY_SUBCLASSES = new ArrayList<>();
    //
    //static {
    //    ENTITY_SUBCLASSES.add(MessageEventSubscriptionEntityImpl.class);
    //    ENTITY_SUBCLASSES.add(SignalEventSubscriptionEntityImpl.class);
    //    ENTITY_SUBCLASSES.add(CompensateEventSubscriptionEntityImpl.class);
    //}

    //protected CachedEntityMatcher<EventSubscriptionEntity> eventSubscriptionsByNameMatcher = new EventSubscriptionsByNameMatcher();
    //
    //protected CachedEntityMatcher<EventSubscriptionEntity> eventSubscriptionsByExecutionIdMatcher = new EventSubscriptionsByExecutionIdMatcher();
    //
    //protected CachedEntityMatcher<EventSubscriptionEntity> eventSubscriptionsBySubScopeIdMatcher = new EventSubscriptionsBySubScopeIdMatcher();
    //
    //protected CachedEntityMatcher<EventSubscriptionEntity> eventSubscriptionsByProcInstTypeAndActivityMatcher = new EventSubscriptionsByProcInstTypeAndActivityMatcher();
    //
    //protected CachedEntityMatcher<EventSubscriptionEntity> eventSubscriptionsByExecutionAndTypeMatcher = new EventSubscriptionsByExecutionAndTypeMatcher();
    //
    //protected CachedEntityMatcher<EventSubscriptionEntity> eventSubscriptionsByScopeDefinitionIdAndTypeMatcher = new EventSubscriptionsByScopeDefinitionIdAndTypeMatcher();
    //
    //protected CachedEntityMatcher<EventSubscriptionEntity> signalEventSubscriptionByNameAndExecutionMatcher = new SignalEventSubscriptionByNameAndExecutionMatcher();
    //
    //protected CachedEntityMatcher<EventSubscriptionEntity> signalEventSubscriptionByProcInstAndEventNameMatcher = new SignalEventSubscriptionByProcInstAndEventNameMatcher();
    //
    //protected CachedEntityMatcher<EventSubscriptionEntity> signalEventSubscriptionByScopeAndEventNameMatcher = new SignalEventSubscriptionByScopeAndEventNameMatcher();
    //
    //protected CachedEntityMatcher<EventSubscriptionEntity> signalEventSubscriptionByScopeIdAndTypeMatcher = new SignalEventSubscriptionByScopeIdAndTypeMatcher();
    //
    //protected CachedEntityMatcher<EventSubscriptionEntity> signalEventSubscriptionByEventNameMatcher = new SignalEventSubscriptionByEventNameMatcher();
    //
    //protected CachedEntityMatcher<EventSubscriptionEntity> messageEventSubscriptionsByProcInstAndEventNameMatcher = new MessageEventSubscriptionsByProcInstAndEventNameMatcher();

    this(EventSubscriptionServiceConfiguration eventSubscriptionServiceConfiguration) {
        this.eventSubscriptionServiceConfiguration = eventSubscriptionServiceConfiguration;
        super(entityManagerFactory.currentEntityManager());
    }


  public void insert(EventSubscriptionEntity entity) {
    insert(cast(EventSubscriptionEntityImpl)entity);
    //getDbSqlSession().insert(entity);
  }
  public EventSubscriptionEntity update(EventSubscriptionEntity entity) {
    return  update(cast(EventSubscriptionEntityImpl)entity);
    //getDbSqlSession().update(entity);
    //return entity;
  }
  public void dele(string id) {
    EventSubscriptionEntity entity = findById(id);
    if (entity !is null)
    {
      remove(cast(EventSubscriptionEntityImpl)entity);
    }
    //delete(entity);
  }

  public void dele(EventSubscriptionEntity entity) {
    if (entity !is null)
    {
      remove(cast(EventSubscriptionEntityImpl)entity);
    }
    //getDbSqlSession().delete(entity);
  }

  public EventSubscriptionEntity findById(string executionId) {
    //if (isExecutionTreeFetched(executionId)) {
    //    return getEntityCache().findInCache(getManagedEntityClass(), executionId);
    //}
    //return super.findById(executionId);
    return find(executionId);
  }

    //
    //public Class<? extends EventSubscriptionEntity> getManagedEntityClass() {
    //    return EventSubscriptionEntityImpl.class;
    //}
    //
    //
    //public List<Class<? extends EventSubscriptionEntity>> getManagedEntitySubClasses() {
    //    return ENTITY_SUBCLASSES;
    //}

    override
    public EventSubscriptionEntity create() {
        // only allowed to create subclasses
        throw new UnsupportedOperationException();
    }


    public CompensateEventSubscriptionEntity createCompensateEventSubscription() {
        return new CompensateEventSubscriptionEntityImpl();
    }


    public MessageEventSubscriptionEntity createMessageEventSubscription() {
        return new MessageEventSubscriptionEntityImpl();
    }


    public SignalEventSubscriptionEntity createSignalEventSubscription() {
        return new SignalEventSubscriptionEntityImpl();
    }


    public GenericEventSubscriptionEntity createGenericEventSubscriptionEntity() {
        return new GenericEventSubscriptionEntityImpl();
    }


    public long findEventSubscriptionCountByQueryCriteria(EventSubscriptionQueryImpl eventSubscriptionQueryImpl) {
      implementationMissing(false);
       return 0;
        // string query = "selectEventSubscriptionCountByQueryCriteria";
        //return (Long) getDbSqlSession().selectOne(query, eventSubscriptionQueryImpl);
    }



    public List!EventSubscription findEventSubscriptionsByQueryCriteria(EventSubscriptionQueryImpl eventSubscriptionQueryImpl) {
        implementationMissing(false);
        return new ArrayList!EventSubscription;
        // string query = "selectEventSubscriptionByQueryCriteria";
        //return getDbSqlSession().selectList(query, eventSubscriptionQueryImpl, getManagedEntityClass());
    }


    public List!MessageEventSubscriptionEntity findMessageEventSubscriptionsByProcessInstanceAndEventName( string processInstanceId,  string eventName) {
        implementationMissing(false);
        return null;
      //Map<string, string> params = new HashMap<>();
        //params.put("processInstanceId", processInstanceId);
        //params.put("eventName", eventName);
        //return toMessageEventSubscriptionEntityList(getList("selectMessageEventSubscriptionsByProcessInstanceAndEventName",
        //        params, messageEventSubscriptionsByProcInstAndEventNameMatcher, true));
    }


    public List!SignalEventSubscriptionEntity findSignalEventSubscriptionsByEventName( string eventName,  string tenantId) {
        implementationMissing(false);
        return null;
        // string query = "selectSignalEventSubscriptionsByEventName";
        //
        // Map<string, string> params = new HashMap<>();
        //params.put("eventName", eventName);
        //if (tenantId !is null && !tenantId.equals(EventSubscriptionServiceConfiguration.NO_TENANT_ID)) {
        //    params.put("tenantId", tenantId);
        //}
        //
        //List<EventSubscriptionEntity> result = getList(query, params, signalEventSubscriptionByEventNameMatcher, true);
        //return toSignalEventSubscriptionEntityList(result);
    }


    public List!SignalEventSubscriptionEntity findSignalEventSubscriptionsByProcessInstanceAndEventName( string processInstanceId,  string eventName) {
         implementationMissing(false);
        return null;
        // string query = "selectSignalEventSubscriptionsByProcessInstanceAndEventName";
        //Map<string, string> params = new HashMap<>();
        //params.put("processInstanceId", processInstanceId);
        //params.put("eventName", eventName);
        //return toSignalEventSubscriptionEntityList(getList(query, params, signalEventSubscriptionByProcInstAndEventNameMatcher, true));
    }


    public List!SignalEventSubscriptionEntity findSignalEventSubscriptionsByScopeAndEventName( string scopeId,  string scopeType,  string eventName) {
        implementationMissing(false);
       return null;
        // string query = "selectSignalEventSubscriptionsByScopeAndEventName";
        //Map<string, string> params = new HashMap<>();
        //params.put("scopeId", scopeId);
        //params.put("scopeType", scopeType);
        //params.put("eventName", eventName);
        //return toSignalEventSubscriptionEntityList(getList(query, params, signalEventSubscriptionByScopeAndEventNameMatcher, true));
    }


    public List!SignalEventSubscriptionEntity findSignalEventSubscriptionsByNameAndExecution( string name,  string executionId) {
        implementationMissing(false);
        return null;
        //Map<string, string> params = new HashMap<>();
        //params.put("executionId", executionId);
        //params.put("eventName", name);
        //return toSignalEventSubscriptionEntityList(getList("selectSignalEventSubscriptionsByNameAndExecution", params, signalEventSubscriptionByNameAndExecutionMatcher, true));
    }


    public List!EventSubscriptionEntity findEventSubscriptionsByExecutionAndType( string executionId,  string type) {
        implementationMissing(false);
        return null;
        //Map<string, string> params = new HashMap<>();
        //params.put("executionId", executionId);
        //params.put("eventType", type);
        //return getList("selectEventSubscriptionsByExecutionAndType", params, eventSubscriptionsByExecutionAndTypeMatcher, true);
    }


    public List!EventSubscriptionEntity findEventSubscriptionsByProcessInstanceAndActivityId( string processInstanceId,  string activityId,  string type) {
         implementationMissing(false);
        return null;
        //Map<string, string> params = new HashMap<>();
        //params.put("processInstanceId", processInstanceId);
        //params.put("eventType", type);
        //params.put("activityId", activityId);
        //return getList("selectEventSubscriptionsByProcessInstanceTypeAndActivity", params, eventSubscriptionsByProcInstTypeAndActivityMatcher, true);
    }


    public List!EventSubscriptionEntity findEventSubscriptionsByExecution( string executionId) {
        implementationMissing(false);
        return null;
        //DbSqlSession dbSqlSession = getDbSqlSession();
        //
        //// If the execution has been inserted in the same command execution as this query, there can't be any in the database
        //if (isEntityInserted(dbSqlSession, "execution", executionId)) {
        //    return getListFromCache(eventSubscriptionsByExecutionIdMatcher, executionId);
        //}
        //
        //return getList(dbSqlSession, "selectEventSubscriptionsByExecution", executionId, eventSubscriptionsByExecutionIdMatcher, true);
    }


    public List!EventSubscriptionEntity findEventSubscriptionsBySubScopeId( string subScopeId) {
        implementationMissing(false);
        return null;
        //DbSqlSession dbSqlSession = getDbSqlSession();
        //
        //// If the sub scope has been inserted in the same command execution as this query, there can't be any in the database
        //if (isEntityInserted(dbSqlSession, "subScopeId", subScopeId)) {
        //    return getListFromCache(eventSubscriptionsBySubScopeIdMatcher, subScopeId);
        //}
        //
        //return getList(dbSqlSession, "selectEventSubscriptionsBySubScopeId", subScopeId, eventSubscriptionsBySubScopeIdMatcher, true);
    }



    public List!EventSubscriptionEntity findEventSubscriptionsByTypeAndProcessDefinitionId(string type, string processDefinitionId, string tenantId) {
        scope(exit)
        {
          _manager.close();
        }

        string query = "SELECT * FROM EventSubscriptionEntityImpl u WHERE "~((type is null || type.length == 0) ? "" :(" u.eventType = :type"));
        query = query ~ " AND u.processDefinitionId = :processDefinitionId";
        query = query ~ " AND (u.executionId is null OR u.executionId = '')";
        query = query ~ " AND (u.processInstanceId is null OR u.processInstanceId = '') AND";
        query = query ~ ((tenantId !is null && tenantId.length != 0) ? (" u.tenantId = :tenantId"): " (u.tenantId = '' OR u.tenantId is null)");

        //logInfof("query : %s",query);
        auto queryBuilder =  _manager.createQuery!(EventSubscriptionEntityImpl)(query);
        if(type !is null && type.length != 0)
        {
            queryBuilder.setParameter("type",type);
        }
        queryBuilder.setParameter("processDefinitionId",processDefinitionId);
        if (tenantId !is null && tenantId.length != 0)
        {
            queryBuilder.setParameter("tenantId",tenantId);
        }

        EventSubscriptionEntityImpl[] array =  queryBuilder.getResultList();

        List!EventSubscriptionEntity rt = new ArrayList!EventSubscriptionEntity;
        foreach(EventSubscriptionEntityImpl e; array)
        {
             rt.add(cast(EventSubscriptionEntity)e);
        }

        return rt;
        // string query = "selectEventSubscriptionsByTypeAndProcessDefinitionId";
        //Map<string, string> params = new HashMap<>();
        //if (type !is null) {
        //    params.put("eventType", type);
        //}
        //params.put("processDefinitionId", processDefinitionId);
        //if (tenantId !is null && !tenantId.equals(EventSubscriptionServiceConfiguration.NO_TENANT_ID)) {
        //    params.put("tenantId", tenantId);
        //}
        //return getDbSqlSession().selectList(query, params);
        //implementationMissing(false);
        //return null;
    }


    public List!EventSubscriptionEntity findEventSubscriptionsByName( string type,  string eventName,  string tenantId) {
         implementationMissing(false);
        return null;
        //Map<string, string> params = new HashMap<>();
        //params.put("eventType", type);
        //params.put("eventName", eventName);
        //if (tenantId !is null && !tenantId.equals(EventSubscriptionServiceConfiguration.NO_TENANT_ID)) {
        //    params.put("tenantId", tenantId);
        //}
        //
        //return getList("selectEventSubscriptionsByName", params, eventSubscriptionsByNameMatcher, true);
    }



    public List!EventSubscriptionEntity findEventSubscriptionsByNameAndExecution(string type, string eventName, string executionId) {
        implementationMissing(false);
        return null;
        // string query = "selectEventSubscriptionsByNameAndExecution";
        //Map<string, string> params = new HashMap<>();
        //params.put("eventType", type);
        //params.put("eventName", eventName);
        //params.put("executionId", executionId);
        //return getDbSqlSession().selectList(query, params);
    }


    public MessageEventSubscriptionEntity findMessageStartEventSubscriptionByName(string messageName, string tenantId) {
        implementationMissing(false);
        return null;
        //Map<string, string> params = new HashMap<>();
        //params.put("eventName", messageName);
        //if (tenantId !is null && !tenantId.equals(EventSubscriptionServiceConfiguration.NO_TENANT_ID)) {
        //    params.put("tenantId", tenantId);
        //}
        //MessageEventSubscriptionEntity entity = (MessageEventSubscriptionEntity) getDbSqlSession().selectOne("selectMessageStartEventSubscriptionByName", params);
        //return entity;
    }


    public void updateEventSubscriptionTenantId(string oldTenantId, string newTenantId) {
        implementationMissing(false);
        //Map<string, string> params = new HashMap<>();
        //params.put("oldTenantId", oldTenantId);
        //params.put("newTenantId", newTenantId);
        //getDbSqlSession().update("updateTenantIdOfEventSubscriptions", params);
    }


    public void deleteEventSubscriptionsForProcessDefinition(string processDefinitionId) {
        implementationMissing(false);
       // getDbSqlSession().delete("deleteEventSubscriptionsForProcessDefinition", processDefinitionId, EventSubscriptionEntityImpl.class);
    }


    public void deleteEventSubscriptionsByExecutionId(string executionId) {
        implementationMissing(false);
        //DbSqlSession dbSqlSession = getDbSqlSession();
        //if (isEntityInserted(dbSqlSession, "execution", executionId)) {
        //    deleteCachedEntities(dbSqlSession, eventSubscriptionsByExecutionIdMatcher, executionId);
        //} else {
        //    bulkDelete("deleteEventSubscriptionsByExecutionId", eventSubscriptionsByExecutionIdMatcher, executionId);
        //}
    }


    public void deleteEventSubscriptionsForScopeIdAndType(string scopeId, string scopeType) {
        implementationMissing(false);
        //Map<string, string> params = new HashMap<>();
        //params.put("scopeId", scopeId);
        //params.put("scopeType", scopeType);
        //bulkDelete("deleteEventSubscriptionsForScopeIdAndType", signalEventSubscriptionByScopeIdAndTypeMatcher, params);
    }


    public void deleteEventSubscriptionsForScopeDefinitionIdAndType(string scopeDefinitionId, string scopeType) {
        implementationMissing(false);
        //Map<string, string> params = new HashMap<>();
        //params.put("scopeDefinitionId", scopeDefinitionId);
        //params.put("scopeType", scopeType);
        //bulkDelete("deleteEventSubscriptionsForScopeDefinitionIdAndType", eventSubscriptionsByScopeDefinitionIdAndTypeMatcher, params);
    }

    protected List!SignalEventSubscriptionEntity toSignalEventSubscriptionEntityList(List!EventSubscriptionEntity result) {
        implementationMissing(false);
        return null;
        //List<SignalEventSubscriptionEntity> signalEventSubscriptionEntities = new ArrayList<>(result.size());
        //for (EventSubscriptionEntity eventSubscriptionEntity : result) {
        //    signalEventSubscriptionEntities.add((SignalEventSubscriptionEntity) eventSubscriptionEntity);
        //}
        //return signalEventSubscriptionEntities;
    }

    protected List!MessageEventSubscriptionEntity toMessageEventSubscriptionEntityList(List!EventSubscriptionEntity result) {
        implementationMissing(false);
        return null;
        //List<MessageEventSubscriptionEntity> messageEventSubscriptionEntities = new ArrayList<>(result.size());
        //for (EventSubscriptionEntity eventSubscriptionEntity : result) {
        //    messageEventSubscriptionEntities.add((MessageEventSubscriptionEntity) eventSubscriptionEntity);
        //}
        //return messageEventSubscriptionEntities;
    }

}
