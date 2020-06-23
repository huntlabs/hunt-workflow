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
//module flow.idm.engine.impl.persistence.entity.data.impl.MybatisIdentityInfoDataManager;
//
//import hunt.collection.HashMap;
//import hunt.collection.List;
//import hunt.collection.Map;
//
//import flow.idm.engine.IdmEngineConfiguration;
//import flow.idm.engine.impl.persistence.entity.IdentityInfoEntity;
//import flow.idm.engine.impl.persistence.entity.IdentityInfoEntityImpl;
//import flow.idm.engine.impl.persistence.entity.data.AbstractIdmDataManager;
//import flow.idm.engine.impl.persistence.entity.data.IdentityInfoDataManager;
//import hunt.entity;
//import hunt.Exceptions;
//import flow.common.AbstractEngineConfiguration;
///**
// * @author Joram Barrez
// */
//class MybatisIdentityInfoDataManager : EntityRepository!( IdentityInfoEntityImpl , string), IdentityInfoDataManager {
////class MybatisIdentityInfoDataManager extends AbstractIdmDataManager!IdentityInfoEntity implements IdentityInfoDataManager {
//
//    public IdmEngineConfiguration idmEngineConfiguration;
//
//    this(IdmEngineConfiguration idmEngineConfiguration) {
//        //super(idmEngineConfiguration);
//        this.idmEngineConfiguration = idmEngineConfiguration;
//        super(entityManagerFactory.currentEntityManager());
//    }
//
//    //
//    //class<? extends IdentityInfoEntity> getManagedEntityClass() {
//    //    return IdentityInfoEntityImpl.class;
//    //}
//
//
//    public IdentityInfoEntity create() {
//        return new IdentityInfoEntityImpl();
//    }
//
//
//    public List!IdentityInfoEntity findIdentityInfoDetails(string identityInfoId) {
//        implementationMissing(false);
//        return null;
//        //return getDbSqlSession().getSqlSession().selectList("selectIdentityInfoDetails", identityInfoId);
//    }
//
//
//
//    public List!IdentityInfoEntity findIdentityInfoByUserId(string userId) {
//        implementationMissing(false);
//        return null;
//      //return getDbSqlSession().selectList("selectIdentityInfoByUserId", userId);
//    }
//
//
//    public IdentityInfoEntity findUserInfoByUserIdAndKey(string userId, string key) {
//        implementationMissing(false);
//        return null;
//        //Map<string, string> parameters = new HashMap<>();
//        //parameters.put("userId", userId);
//        //parameters.put("key", key);
//        //return (IdentityInfoEntity) getDbSqlSession().selectOne("selectIdentityInfoByUserIdAndKey", parameters);
//    }
//
//
//
//    public List!string findUserInfoKeysByUserIdAndType(string userId, string type) {
//        implementationMissing(false);
//        return null;
//        //Map<string, string> parameters = new HashMap<>();
//        //parameters.put("userId", userId);
//        //parameters.put("type", type);
//        //return (List) getDbSqlSession().getSqlSession().selectList("selectIdentityInfoKeysByUserIdAndType", parameters);
//    }
//
//}
