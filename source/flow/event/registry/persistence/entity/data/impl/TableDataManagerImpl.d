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

//
//import hunt.collection;
//import hunt.collection.HashMap;
//import hunt.collection.Map;
//
//import flow.common.persistence.entity.Entity;
//import flow.event.registry.persistence.entity.ChannelDefinitionEntity;
//import flow.event.registry.persistence.entity.EventDefinitionEntity;
//import flow.event.registry.persistence.entity.EventDeploymentEntity;
//import flow.event.registry.persistence.entity.EventResourceEntity;
//import flow.event.registry.persistence.entity.data.TableDataManager;
//import flow.event.registry.util.CommandContextUtil;
//
///**
// * @author Joram Barrez
// */
//class TableDataManagerImpl implements TableDataManager {
//
//    public static Map<Class<? extends Entity>, String> entityToTableNameMap = new HashMap<>();
//
//    static {
//        entityToTableNameMap.put(EventDeploymentEntity.class, "FLW_EVENT_DEPLOYMENT");
//        entityToTableNameMap.put(EventResourceEntity.class, "FLW_EVENT_RESOURCE");
//        entityToTableNameMap.put(EventDefinitionEntity.class, "FLW_EVENT_DEFINITION");
//        entityToTableNameMap.put(ChannelDefinitionEntity.class, "FLW_CHANNEL_DEFINITION");
//    }
//
//    public TableDataManagerImpl() {
//    }
//
//    @Override
//    public Map<String, Long> getTableCount() {
//        Map<String, Long> counts = new HashMap<>();
//        for (String table : getTablesPresentInDatabase()) {
//            counts.put(table, (Long) CommandContextUtil.getDbSqlSession().selectOne("flow.event.registry.TableData.selectTableCount", table));
//        }
//        return counts;
//    }
//
//    @Override
//    public Collection!String getTablesPresentInDatabase() {
//        return entityToTableNameMap.values();
//    }
//
//    @Override
//    public String getTableName(Class<?> entityClass, boolean withPrefix) {
//        String databaseTablePrefix = CommandContextUtil.getDbSqlSession().getDbSqlSessionFactory().getDatabaseTablePrefix();
//        String tableName = entityToTableNameMap.get(entityClass);
//        if (withPrefix) {
//            return databaseTablePrefix + tableName;
//        } else {
//            return tableName;
//        }
//    }
//
//}
