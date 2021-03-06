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
//module flow.common.db.DbSqlSession;
//
//import flow.common.db.DbSqlSessionFactory;
////import java.sql.Connection;
//import hunt.collection.ArrayList;
//import hunt.collection;
//import hunt.collection.HashMap;
//import hunt.collection.HashSet;
//import hunt.collection.Iterator;
//import hunt.collection.LinkedHashMap;
//import hunt.collection.List;
//import hunt.collection.Map;
//import hunt.collection.Set;
//
////import org.apache.ibatis.session.SqlSession;
//import flow.common.api.FlowableException;
//import flow.common.api.FlowableOptimisticLockingException;
//import flow.common.api.query.QueryCacheValues;
//import flow.common.Page;
//import flow.common.context.Context;
//import flow.common.interceptor.Session;
//import flow.common.persistence.cache.CachedEntity;
//import flow.common.persistence.cache.EntityCache;
//import flow.common.persistence.entity.AlwaysUpdatedPersistentObject;
//import flow.common.persistence.entity.Entity;
//
///**
// * @author Tom Baeyens
// * @author Joram Barrez
// */
//class DbSqlSession : Session {
//
//    static enum string[] JDBC_METADATA_TABLE_TYPES = { "TABLE" };
//
//    //protected EntityCache entityCache;
//    //protected SqlSession sqlSession;
//    protected DbSqlSessionFactory dbSqlSessionFactory;
//    protected string connectionMetadataDefaultCatalog;
//    protected string connectionMetadataDefaultSchema;
//
//    protected Map!(TypeInfo, Map!(string, Entity) insertedObjects ;// = new HashMap<>();
//    protected Map!(TypeInfo, Map!(string, Entity)) deletedObjects ;// = new HashMap<>();
//    protected Map!(TypeInfo, List!BulkDeleteOperation) bulkDeleteOperations ;// = new HashMap<>();
//    protected List!Entity updatedObjects ;// = new ArrayList<>();
//
//    this(DbSqlSessionFactory dbSqlSessionFactory, EntityCache entityCache) {
//        this.dbSqlSessionFactory = dbSqlSessionFactory;
//        this.entityCache = entityCache;
//        insertedObjects = new HashMap!(TypeInfo, Map!(string, Entity);
//        deletedObjects = new HashMap!(TypeInfo, Map!(string, Entity));
//        //this.sqlSession = dbSqlSessionFactory.getSqlSessionFactory().openSession();
//    }
//
//    this(DbSqlSessionFactory dbSqlSessionFactory, EntityCache entityCache, Connection connection, string catalog, string schema) {
//        this.dbSqlSessionFactory = dbSqlSessionFactory;
//        this.entityCache = entityCache;
//        this.sqlSession = dbSqlSessionFactory.getSqlSessionFactory().openSession(connection); // Note the use of connection param here, different from other constructor
//        this.connectionMetadataDefaultCatalog = catalog;
//        this.connectionMetadataDefaultSchema = schema;
//    }
//
//    // insert ///////////////////////////////////////////////////////////////////
//
//    public void insert(Entity entity) {
//        if (entity.getId() is null) {
//            string id = Context.getCommandContext().getCurrentEngineConfiguration().getIdGenerator().getNextId();
//            if (dbSqlSessionFactory.isUsePrefixId()) {
//                id = entity.getIdPrefix() + id;
//            }
//            entity.setId(id);
//        }
//
//        Class<? extends Entity> clazz = entity.getClass();
//        if (!insertedObjects.containsKey(clazz)) {
//            insertedObjects.put(clazz, new LinkedHashMap<>()); // order of insert is important, hence LinkedHashMap
//        }
//
//        insertedObjects.get(clazz).put(entity.getId(), entity);
//        entityCache.put(entity, false); // False -> entity is inserted, so always changed
//        entity.setInserted(true);
//    }
//
//    // update
//    // ///////////////////////////////////////////////////////////////////
//
//    public void update(Entity entity) {
//        entityCache.put(entity, false); // false -> we don't store state, meaning it will always be seen as changed
//        entity.setUpdated(true);
//    }
//
//    public int update(string statement, Object parameters) {
//        string updateStatement = dbSqlSessionFactory.mapStatement(statement);
//        return getSqlSession().update(updateStatement, parameters);
//    }
//
//    // delete
//    // ///////////////////////////////////////////////////////////////////
//
//    /**
//     * Executes a {@link BulkDeleteOperation}, with the sql in the statement parameter.
//     * The passed class determines when this operation will be executed: it will be executed depending on the place of the class in the {@link EntityDependencyOrder}.
//     */
//    public void delete(string statement, Object parameter, Class<? extends Entity> entityClass) {
//        if (!bulkDeleteOperations.containsKey(entityClass)) {
//            bulkDeleteOperations.put(entityClass, new ArrayList<>(1));
//        }
//        bulkDeleteOperations.get(entityClass).add(new BulkDeleteOperation(dbSqlSessionFactory.mapStatement(statement), parameter));
//    }
//
//    public void delete(Entity entity) {
//        Class<? extends Entity> clazz = entity.getClass();
//        if (!deletedObjects.containsKey(clazz)) {
//            deletedObjects.put(clazz, new LinkedHashMap<>()); // order of insert is important, hence LinkedHashMap
//        }
//        deletedObjects.get(clazz).put(entity.getId(), entity);
//        entity.setDeleted(true);
//    }
//
//    // select
//    // ///////////////////////////////////////////////////////////////////
//
//    @SuppressWarnings({ "rawtypes" })
//    public List selectList(string statement) {
//        return selectList(statement, null, -1, -1);
//    }
//
//    @SuppressWarnings("rawtypes")
//    public List selectList(string statement, Object parameter) {
//        return selectList(statement, parameter, -1, -1);
//    }
//
//    @SuppressWarnings("rawtypes")
//    public List selectList(string statement, Object parameter, Page page) {
//        if (page !is null) {
//            return selectList(statement, parameter, page.getFirstResult(), page.getMaxResults());
//        } else {
//            return selectList(statement, parameter, -1, -1);
//        }
//    }
//
//    @SuppressWarnings("rawtypes")
//    public List selectList(string statement, ListQueryParameterObject parameter) {
//        parameter.setDatabaseType(dbSqlSessionFactory.getDatabaseType());
//        return selectListWithRawParameter(statement, parameter);
//    }
//
//    @SuppressWarnings("rawtypes")
//    public List selectList(string statement, ListQueryParameterObject parameter, Class entityClass) {
//        parameter.setDatabaseType(dbSqlSessionFactory.getDatabaseType());
//        if (parameter instanceof QueryCacheValues) {
//            return queryWithRawParameter(statement, (QueryCacheValues) parameter, entityClass, true);
//        } else {
//            return selectListWithRawParameter(statement, parameter);
//        }
//    }
//
//    @SuppressWarnings("rawtypes")
//    public List selectList(string statement, Object parameter, int firstResult, int maxResults) {
//        return selectList(statement, new ListQueryParameterObject(parameter, firstResult, maxResults));
//    }
//
//    @SuppressWarnings("rawtypes")
//    public List selectListNoCacheLoadAndStore(string statement, Object parameter) {
//        return selectListWithRawParameter(statement, new ListQueryParameterObject(parameter, -1, -1), false);
//    }
//
//    @SuppressWarnings({ "rawtypes" })
//    public List selectListWithRawParameterNoCacheLoadAndStore(string statement, Object parameter) {
//        return selectListWithRawParameter(statement, parameter, false);
//    }
//
//    @SuppressWarnings({ "rawtypes" })
//    public List selectListWithRawParameterNoCacheLoadAndStore(string statement, ListQueryParameterObject parameter, Class entityClass) {
//        parameter.setDatabaseType(dbSqlSessionFactory.getDatabaseType());
//
//        if (parameter instanceof QueryCacheValues) {
//            return queryWithRawParameter(statement, (QueryCacheValues) parameter, entityClass, false);
//        } else {
//            return selectListWithRawParameter(statement, parameter, false);
//        }
//    }
//
//    @SuppressWarnings({ "rawtypes" })
//    public List selectListWithRawParameterNoCacheLoadAndStore(string statement, ListQueryParameterObject parameter) {
//        parameter.setDatabaseType(dbSqlSessionFactory.getDatabaseType());
//        return selectListWithRawParameter(statement, parameter, false);
//    }
//
//    @SuppressWarnings("rawtypes")
//    public List selectListNoCacheLoadAndStore(string statement, ListQueryParameterObject parameter, Class entityClass) {
//        ListQueryParameterObject parameterToUse = parameter;
//        if (parameterToUse is null) {
//            parameterToUse = new ListQueryParameterObject();
//        }
//        parameterToUse.setDatabaseType(dbSqlSessionFactory.getDatabaseType());
//
//        if (parameter instanceof QueryCacheValues) {
//            return queryWithRawParameter(statement, (QueryCacheValues) parameter, entityClass, false);
//        } else {
//            return selectListWithRawParameter(statement, parameterToUse, false);
//        }
//    }
//
//    @SuppressWarnings("rawtypes")
//    public List selectListNoCacheLoadAndStore(string statement, ListQueryParameterObject parameter) {
//        ListQueryParameterObject parameterToUse = parameter;
//        if (parameterToUse is null) {
//            parameterToUse = new ListQueryParameterObject();
//        }
//        parameterToUse.setDatabaseType(dbSqlSessionFactory.getDatabaseType());
//
//        return selectListWithRawParameter(statement, parameterToUse, false);
//    }
//
//    @SuppressWarnings("rawtypes")
//    public List selectListWithRawParameter(string statement, Object parameter) {
//        // All other selectList methods eventually end up here, passing it into the method
//        // with the useCache parameter. By default true, which means everything is cached.
//        // Dedicated xNoCacheCheck methods will pass a false for that setting.
//        return selectListWithRawParameter(statement, parameter, true);
//    }
//
//    @SuppressWarnings({ "rawtypes", "unchecked" })
//    public List queryWithRawParameter(string statement, QueryCacheValues parameter, Class entityClass, boolean cacheLoadAndStore) {
//        if (parameter.getId() !is null && !parameter.getId().isEmpty()) {
//            Object entity = entityCache.findInCache(entityClass, parameter.getId());
//            if (entity !is null) {
//                List resultList = new ArrayList<>();
//                resultList.add(entity);
//                return resultList;
//            }
//        }
//
//        return selectListWithRawParameter(statement, parameter, cacheLoadAndStore);
//    }
//
//    @SuppressWarnings({ "rawtypes", "unchecked" })
//    public List queryWithRawParameterNoCacheLoadAndStore(string statement, QueryCacheValues parameter, Class entityClass) {
//        if (parameter.getId() !is null && !parameter.getId().isEmpty()) {
//            Object entity = entityCache.findInCache(entityClass, parameter.getId());
//            if (entity !is null) {
//                List resultList = new ArrayList<>();
//                resultList.add(entity);
//                return resultList;
//            }
//        }
//
//        statement = dbSqlSessionFactory.mapStatement(statement);
//        return sqlSession.selectList(statement, parameter);
//    }
//
//    @SuppressWarnings({ "rawtypes", "unchecked" })
//    public List selectListWithRawParameter(string statement, Object parameter, boolean useCache) {
//        statement = dbSqlSessionFactory.mapStatement(statement);
//        List loadedObjects = sqlSession.selectList(statement, parameter);
//        if (useCache) {
//            return cacheLoadOrStore(loadedObjects);
//        } else {
//            return loadedObjects;
//        }
//    }
//
//    public Object selectOne(string statement, Object parameter) {
//        statement = dbSqlSessionFactory.mapStatement(statement);
//        Object result = sqlSession.selectOne(statement, parameter);
//        if (result instanceof Entity) {
//            Entity loadedObject = (Entity) result;
//            result = cacheLoadOrStore(loadedObject);
//        }
//        return result;
//    }
//
//    public <T extends Entity> T selectById(Class<T> entityClass, string id) {
//        return selectById(entityClass, id, true);
//    }
//
//    @SuppressWarnings("unchecked")
//    public <T extends Entity> T selectById(Class<T> entityClass, string id, boolean useCache) {
//        T entity = null;
//
//        if (useCache) {
//            entity = entityCache.findInCache(entityClass, id);
//            if (entity !is null) {
//                return entity;
//            }
//        }
//
//        string selectStatement = dbSqlSessionFactory.getSelectStatement(entityClass);
//        selectStatement = dbSqlSessionFactory.mapStatement(selectStatement);
//        entity = (T) sqlSession.selectOne(selectStatement, id);
//        if (entity is null) {
//            return null;
//        }
//
//        entityCache.put(entity, true); // true -> store state so we can see later if it is updated later on
//        return entity;
//    }
//
//    // internal session cache
//    // ///////////////////////////////////////////////////
//
//    @SuppressWarnings("rawtypes")
//    protected List cacheLoadOrStore(List<Object> loadedObjects) {
//        if (loadedObjects.isEmpty()) {
//            return loadedObjects;
//        }
//        if (!(loadedObjects.get(0) instanceof Entity)) {
//            return loadedObjects;
//        }
//
//        List<Entity> filteredObjects = new ArrayList<>(loadedObjects.size());
//        for (Object loadedObject : loadedObjects) {
//            Entity cachedEntity = cacheLoadOrStore((Entity) loadedObject);
//            filteredObjects.add(cachedEntity);
//        }
//        return filteredObjects;
//    }
//
//    /**
//     * Returns the object in the cache. If this object was loaded before, then the original object is returned (the cached version is more recent). If this is the first time this object is loaded,
//     * then the loadedObject is added to the cache.
//     */
//    protected Entity cacheLoadOrStore(Entity entity) {
//        Entity cachedEntity = entityCache.findInCache(entity.getClass(), entity.getId());
//        if (cachedEntity !is null) {
//            return cachedEntity;
//        }
//        entityCache.put(entity, true);
//        return entity;
//    }
//
//    // flush
//    // ////////////////////////////////////////////////////////////////////
//
//    @Override
//    public void flush() {
//        determineUpdatedObjects(); // Needs to be done before the removeUnnecessaryOperations, as removeUnnecessaryOperations will remove stuff from the cache
//        removeUnnecessaryOperations();
//
//        if (LOGGER.isDebugEnabled()) {
//            debugFlush();
//        }
//
//        flushInserts();
//        flushUpdates();
//        flushDeletes();
//    }
//
//    /**
//     * Clears all deleted and inserted objects from the cache, and removes inserts and deletes that cancel each other.
//     *
//     * Also removes deletes with duplicate ids.
//     */
//    protected void removeUnnecessaryOperations() {
//
//        for (Class<? extends Entity> entityClass : deletedObjects.keySet()) {
//
//            // Collect ids of deleted entities + remove duplicates
//            Set<string> ids = new HashSet<>();
//            Iterator<Entity> entitiesToDeleteIterator = deletedObjects.get(entityClass).values().iterator();
//            while (entitiesToDeleteIterator.hasNext()) {
//                Entity entityToDelete = entitiesToDeleteIterator.next();
//                if (entityToDelete.getId() !is null && !ids.contains(entityToDelete.getId())) {
//                    ids.add(entityToDelete.getId());
//                } else {
//                    entitiesToDeleteIterator.remove(); // Removing duplicate deletes or entities without id
//                }
//            }
//
//            // Now we have the deleted ids, we can remove the inserted objects (as they cancel each other)
//            for (string id : ids) {
//                if (insertedObjects.containsKey(entityClass) && insertedObjects.get(entityClass).containsKey(id)) {
//                    insertedObjects.get(entityClass).remove(id);
//                    deletedObjects.get(entityClass).remove(id);
//                }
//            }
//
//        }
//    }
//
//    public void determineUpdatedObjects() {
//        updatedObjects = new ArrayList<>();
//        Map<Class<?>, Map<string, CachedEntity>> cachedObjects = entityCache.getAllCachedEntities();
//        for (Class<?> clazz : cachedObjects.keySet()) {
//
//            Map<string, CachedEntity> classCache = cachedObjects.get(clazz);
//            for (CachedEntity cachedObject : classCache.values()) {
//
//                Entity cachedEntity = cachedObject.getEntity();
//
//                // Executions are stored as a hierarchical tree, and updates are important to execute
//                // even when the execution are deleted, as they can change the parent-child relationships.
//                // For the other entities, this is not applicable and an update can be discarded when an update follows.
//
//                if (!isEntityInserted(cachedEntity) &&
//                        (cachedEntity instanceof AlwaysUpdatedPersistentObject || !isEntityToBeDeleted(cachedEntity)) &&
//                        cachedObject.hasChanged()) {
//
//                    updatedObjects.add(cachedEntity);
//                }
//            }
//        }
//    }
//
//    protected void debugFlush() {
//        LOGGER.debug("Flushing dbSqlSession");
//        int nrOfInserts = 0;
//        int nrOfUpdates = 0;
//        int nrOfDeletes = 0;
//        for (Map<string, Entity> insertedObjectMap : insertedObjects.values()) {
//            for (Entity insertedObject : insertedObjectMap.values()) {
//                LOGGER.debug("insert {}", insertedObject);
//                nrOfInserts++;
//            }
//        }
//        for (Entity updatedObject : updatedObjects) {
//            LOGGER.debug("update {}", updatedObject);
//            nrOfUpdates++;
//        }
//        for (Map<string, Entity> deletedObjectMap : deletedObjects.values()) {
//            for (Entity deletedObject : deletedObjectMap.values()) {
//                LOGGER.debug("delete {} with id {}", deletedObject, deletedObject.getId());
//                nrOfDeletes++;
//            }
//        }
//        for (Collection<BulkDeleteOperation> bulkDeleteOperationList : bulkDeleteOperations.values()) {
//            for (BulkDeleteOperation bulkDeleteOperation : bulkDeleteOperationList) {
//                LOGGER.debug("{}", bulkDeleteOperation);
//                nrOfDeletes++;
//            }
//        }
//        LOGGER.debug("flush summary: {} insert, {} update, {} delete.", nrOfInserts, nrOfUpdates, nrOfDeletes);
//        LOGGER.debug("now executing flush...");
//    }
//
//    public boolean isEntityInserted(Entity entity) {
//        return isEntityInserted(entity.getClass(), entity.getId());
//    }
//
//    public boolean isEntityInserted(Class<?> entityClass, string entityId) {
//        return insertedObjects.containsKey(entityClass)
//                && insertedObjects.get(entityClass).containsKey(entityId);
//    }
//
//    public boolean isEntityToBeDeleted(Entity entity) {
//        return (deletedObjects.containsKey(entity.getClass())
//                && deletedObjects.get(entity.getClass()).containsKey(entity.getId())) || entity.isDeleted();
//    }
//
//    protected void flushInserts() {
//
//        if (insertedObjects.size() == 0) {
//            return;
//        }
//
//        // Handle in entity dependency order
//        for (Class<? extends Entity> entityClass : dbSqlSessionFactory.getInsertionOrder()) {
//            if (insertedObjects.containsKey(entityClass)) {
//                flushInsertEntities(entityClass, insertedObjects.get(entityClass).values());
//                insertedObjects.remove(entityClass);
//            }
//        }
//
//        // Next, in case of custom entities or we've screwed up and forgotten some entity
//        if (insertedObjects.size() > 0) {
//            for (Class<? extends Entity> entityClass : insertedObjects.keySet()) {
//                flushInsertEntities(entityClass, insertedObjects.get(entityClass).values());
//            }
//        }
//
//        insertedObjects.clear();
//    }
//
//    protected void flushInsertEntities(Class<? extends Entity> entityClass, Collection<Entity> entitiesToInsert) {
//        if (entitiesToInsert.size() == 1) {
//            flushRegularInsert(entitiesToInsert.iterator().next(), entityClass);
//        } else if (Boolean.FALSE.equals(dbSqlSessionFactory.isBulkInsertable(entityClass))) {
//            for (Entity entity : entitiesToInsert) {
//                flushRegularInsert(entity, entityClass);
//            }
//        } else {
//            flushBulkInsert(entitiesToInsert, entityClass);
//        }
//    }
//
//    protected void flushRegularInsert(Entity entity, Class<? extends Entity> clazz) {
//        string insertStatement = dbSqlSessionFactory.getInsertStatement(entity);
//        insertStatement = dbSqlSessionFactory.mapStatement(insertStatement);
//
//        if (insertStatement is null) {
//            throw new FlowableException("no insert statement for " + entity.getClass() + " in the ibatis mapping files");
//        }
//
//        LOGGER.debug("inserting: {}", entity);
//        sqlSession.insert(insertStatement, entity);
//
//        // See https://activiti.atlassian.net/browse/ACT-1290
//        if (entity instanceof HasRevision) {
//            incrementRevision(entity);
//        }
//    }
//
//    protected void flushBulkInsert(Collection<Entity> entities, Class<? extends Entity> clazz) {
//        string insertStatement = dbSqlSessionFactory.getBulkInsertStatement(clazz);
//        insertStatement = dbSqlSessionFactory.mapStatement(insertStatement);
//
//        if (insertStatement is null) {
//            throw new FlowableException("no insert statement for " + entities.iterator().next().getClass() + " in the ibatis mapping files");
//        }
//
//        Iterator<Entity> entityIterator = entities.iterator();
//        Boolean hasRevision = null;
//
//        while (entityIterator.hasNext()) {
//            List<Entity> subList = new ArrayList<>();
//            int index = 0;
//            while (entityIterator.hasNext() && index < dbSqlSessionFactory.getMaxNrOfStatementsInBulkInsert()) {
//                Entity entity = entityIterator.next();
//                subList.add(entity);
//
//                if (hasRevision is null) {
//                    hasRevision = entity instanceof HasRevision;
//                }
//                index++;
//            }
//            sqlSession.insert(insertStatement, subList);
//        }
//
//        if (hasRevision !is null && hasRevision) {
//            entityIterator = entities.iterator();
//            while (entityIterator.hasNext()) {
//                incrementRevision(entityIterator.next());
//            }
//        }
//
//    }
//
//    protected void incrementRevision(Entity insertedObject) {
//        HasRevision revisionEntity = (HasRevision) insertedObject;
//        if (revisionEntity.getRevision() == 0) {
//            revisionEntity.setRevision(revisionEntity.getRevisionNext());
//        }
//    }
//
//    protected void flushUpdates() {
//        for (Entity updatedObject : updatedObjects) {
//            string updateStatement = dbSqlSessionFactory.getUpdateStatement(updatedObject);
//            updateStatement = dbSqlSessionFactory.mapStatement(updateStatement);
//
//            if (updateStatement is null) {
//                throw new FlowableException("no update statement for " + updatedObject.getClass() + " in the ibatis mapping files");
//            }
//
//            LOGGER.debug("updating: {}", updatedObject);
//
//            int updatedRecords = sqlSession.update(updateStatement, updatedObject);
//            if (updatedRecords == 0) {
//                throw new FlowableOptimisticLockingException(updatedObject + " was updated by another transaction concurrently");
//            }
//
//            // See https://activiti.atlassian.net/browse/ACT-1290
//            if (updatedObject instanceof HasRevision) {
//                ((HasRevision) updatedObject).setRevision(((HasRevision) updatedObject).getRevisionNext());
//            }
//
//        }
//        updatedObjects.clear();
//    }
//
//    protected void flushDeletes() {
//
//        if (deletedObjects.size() == 0 && bulkDeleteOperations.size() == 0) {
//            return;
//        }
//
//        // Handle in entity dependency order
//        for (Class<? extends Entity> entityClass : dbSqlSessionFactory.getDeletionOrder()) {
//            if (deletedObjects.containsKey(entityClass)) {
//                flushDeleteEntities(entityClass, deletedObjects.get(entityClass).values());
//                deletedObjects.remove(entityClass);
//            }
//            flushBulkDeletes(entityClass, this.bulkDeleteOperations.remove(entityClass));
//        }
//
//        // Next, in case of custom entities or we've screwed up and forgotten some entity
//        if (deletedObjects.size() > 0) {
//            for (Class<? extends Entity> entityClass : deletedObjects.keySet()) {
//                flushDeleteEntities(entityClass, deletedObjects.get(entityClass).values());
//                flushBulkDeletes(entityClass, this.bulkDeleteOperations.remove(entityClass));
//            }
//        }
//
//        // Last, in case there are still some pending entities or we have forgotten an entity for the bulk operations
//        if (!bulkDeleteOperations.isEmpty()) {
//            bulkDeleteOperations.forEach(this::flushBulkDeletes);
//        }
//
//        deletedObjects.clear();
//        bulkDeleteOperations.clear();
//    }
//
//    protected void flushBulkDeletes(Class<? extends Entity> entityClass, List<BulkDeleteOperation> deleteOperations) {
//        // Bulk deletes
//        if (deleteOperations !is null) {
//            for (BulkDeleteOperation bulkDeleteOperation : deleteOperations) {
//                bulkDeleteOperation.execute(sqlSession, entityClass);
//            }
//        }
//    }
//
//    protected void flushDeleteEntities(Class<? extends Entity> entityClass, Collection<Entity> entitiesToDelete) {
//        for (Entity entity : entitiesToDelete) {
//            string deleteStatement = dbSqlSessionFactory.getDeleteStatement(entity.getClass());
//            deleteStatement = dbSqlSessionFactory.mapStatement(deleteStatement);
//            if (deleteStatement is null) {
//                throw new FlowableException("no delete statement for " + entity.getClass() + " in the ibatis mapping files");
//            }
//
//            // It only makes sense to check for optimistic locking exceptions
//            // for objects that actually have a revision
//            if (entity instanceof HasRevision) {
//                int nrOfRowsDeleted = sqlSession.delete(deleteStatement, entity);
//                if (nrOfRowsDeleted == 0) {
//                    throw new FlowableOptimisticLockingException(entity + " was updated by another transaction concurrently");
//                }
//            } else {
//                sqlSession.delete(deleteStatement, entity);
//            }
//        }
//    }
//
//    @Override
//    public void close() {
//        sqlSession.close();
//    }
//
//    public void commit() {
//        sqlSession.commit();
//    }
//
//    public void rollback() {
//        sqlSession.rollback();
//    }
//
//    public <T> T getCustomMapper(Class<T> type) {
//        return sqlSession.getMapper(type);
//    }
//
//    // getters and setters
//    // //////////////////////////////////////////////////////
//
//    public SqlSession getSqlSession() {
//        return sqlSession;
//    }
//
//    public DbSqlSessionFactory getDbSqlSessionFactory() {
//        return dbSqlSessionFactory;
//    }
//
//    public string getConnectionMetadataDefaultCatalog() {
//        return connectionMetadataDefaultCatalog;
//    }
//
//    public void setConnectionMetadataDefaultCatalog(string connectionMetadataDefaultCatalog) {
//        this.connectionMetadataDefaultCatalog = connectionMetadataDefaultCatalog;
//    }
//
//    public string getConnectionMetadataDefaultSchema() {
//        return connectionMetadataDefaultSchema;
//    }
//
//    public void setConnectionMetadataDefaultSchema(string connectionMetadataDefaultSchema) {
//        this.connectionMetadataDefaultSchema = connectionMetadataDefaultSchema;
//    }
//
//}
