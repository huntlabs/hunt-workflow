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


import java.sql.Connection;
import java.util.Collection;
import java.util.List;

import flow.common.db.BulkDeleteOperation;
import flow.common.db.DbSqlSession;
import flow.common.db.DbSqlSessionFactory;
import flow.common.persistence.cache.EntityCache;
import flow.common.persistence.entity.Entity;

/**
 * @author Joram Barrez
 */
class ProfilingDbSqlSession extends DbSqlSession {

    protected CommandExecutionResult commandExecutionResult;

    public ProfilingDbSqlSession(DbSqlSessionFactory dbSqlSessionFactory, EntityCache entityCache) {
        super(dbSqlSessionFactory, entityCache);
    }

    public ProfilingDbSqlSession(DbSqlSessionFactory dbSqlSessionFactory, EntityCache entityCache, Connection connection, string catalog, string schema) {
        super(dbSqlSessionFactory, entityCache, connection, catalog, schema);
    }

    @Override
    public void flush() {
        long startTime = System.currentTimeMillis();
        super.flush();
        long endTime = System.currentTimeMillis();

        CommandExecutionResult commandExecutionResult = getCurrentCommandExecution();
        if (commandExecutionResult !is null) {
            commandExecutionResult.addDatabaseTime(endTime - startTime);
        }
    }

    @Override
    public void commit() {

        long startTime = System.currentTimeMillis();
        super.commit();
        long endTime = System.currentTimeMillis();

        CommandExecutionResult commandExecutionResult = getCurrentCommandExecution();
        if (commandExecutionResult !is null) {
            commandExecutionResult.addDatabaseTime(endTime - startTime);
        }
    }

    // SELECT ONE

    @Override
    public Object selectOne(string statement, Object parameter) {
        if (getCurrentCommandExecution() !is null) {
            getCurrentCommandExecution().addDbSelect(statement);
        }
        return super.selectOne(statement, parameter);
    }

    @Override
    public <T extends Entity> T selectById(Class<T> entityClass, string id, bool useCache) {
        if (getCurrentCommandExecution() !is null) {
            getCurrentCommandExecution().addDbSelect("selectById " + entityClass.getName());
        }
        return super.selectById(entityClass, id, useCache);
    }

    // SELECT LIST

    @Override
    public List selectListWithRawParameter(string statement, Object parameter, bool useCache) {
        if (getCurrentCommandExecution() !is null) {
            getCurrentCommandExecution().addDbSelect(statement);
        }
        return super.selectListWithRawParameter(statement, parameter, useCache);
    }

    @Override
    public List selectListWithRawParameterNoCacheLoadAndStore(string statement, Object parameter) {
        if (getCurrentCommandExecution() !is null) {
            getCurrentCommandExecution().addDbSelect(statement);
        }
        return super.selectListWithRawParameterNoCacheLoadAndStore(statement, parameter);
    }

    // INSERTS

    @Override
    protected void flushRegularInsert(Entity entity, Class<? extends Entity> clazz) {
        super.flushRegularInsert(entity, clazz);
        if (getCurrentCommandExecution() !is null) {
            getCurrentCommandExecution().addDbInsert(clazz.getName());
        }
    }

    @Override
    protected void flushBulkInsert(Collection<Entity> entities, Class<? extends Entity> clazz) {
        if (getCurrentCommandExecution() !is null && entities.size() > 0) {
            getCurrentCommandExecution().addDbInsert(clazz.getName() + "-bulk-with-" + entities.size());
        }
        super.flushBulkInsert(entities, clazz);
    }

    // UPDATES

    @Override
    protected void flushUpdates() {
        if (getCurrentCommandExecution() !is null) {
            for (Entity persistentObject : updatedObjects) {
                getCurrentCommandExecution().addDbUpdate(persistentObject.getClass().getName());
            }
        }

        super.flushUpdates();
    }

    // DELETES

    @Override
    protected void flushDeleteEntities(Class<? extends Entity> entityClass, Collection<Entity> entitiesToDelete) {
        super.flushDeleteEntities(entityClass, entitiesToDelete);
        if (getCurrentCommandExecution() !is null) {
            for (Entity entity : entitiesToDelete) {
                getCurrentCommandExecution().addDbDelete(entity.getClass().getName());
            }
        }
    }

    @Override
    protected void flushBulkDeletes(Class<? extends Entity> entityClass, List<BulkDeleteOperation> deleteOperations) {
        // Bulk deletes
        if (getCurrentCommandExecution() !is null && deleteOperations !is null) {
            for (BulkDeleteOperation bulkDeleteOperation : deleteOperations) {
                getCurrentCommandExecution().addDbDelete("Bulk-delete-" + bulkDeleteOperation.getStatement());
            }
        }
        super.flushBulkDeletes(entityClass, deleteOperations);
    }

    public CommandExecutionResult getCurrentCommandExecution() {
        if (commandExecutionResult is null) {
            ProfileSession profileSession = FlowableProfiler.getInstance().getCurrentProfileSession();
            if (profileSession !is null) {
                this.commandExecutionResult = profileSession.getCurrentCommandExecution();
            }
        }
        return commandExecutionResult;
    }
}
