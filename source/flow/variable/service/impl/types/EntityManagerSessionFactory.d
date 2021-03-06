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
//
//
//import javax.persistence.EntityManagerFactory;
//
//import flow.common.api.FlowableIllegalArgumentException;
//import flow.common.interceptor.CommandContext;
//import flow.common.interceptor.Session;
//import flow.common.interceptor.SessionFactory;
//
///**
// * @author Frederik Heremans
// */
//class EntityManagerSessionFactory implements SessionFactory {
//
//    protected EntityManagerFactory entityManagerFactory;
//    protected boolean handleTransactions;
//    protected boolean closeEntityManager;
//
//    public EntityManagerSessionFactory(Object entityManagerFactory, boolean handleTransactions, boolean closeEntityManager) {
//        if (entityManagerFactory is null) {
//            throw new FlowableIllegalArgumentException("entityManagerFactory is null");
//        }
//        if (!(entityManagerFactory instanceof EntityManagerFactory)) {
//            throw new FlowableIllegalArgumentException("EntityManagerFactory must implement 'javax.persistence.EntityManagerFactory'");
//        }
//
//        this.entityManagerFactory = (EntityManagerFactory) entityManagerFactory;
//        this.handleTransactions = handleTransactions;
//        this.closeEntityManager = closeEntityManager;
//    }
//
//    @Override
//    public Class<?> getSessionType() {
//        return EntityManagerSession.class;
//    }
//
//    @Override
//    public Session openSession(CommandContext commandContext) {
//        return new EntityManagerSessionImpl(entityManagerFactory, handleTransactions, closeEntityManager);
//    }
//
//    public EntityManagerFactory getEntityManagerFactory() {
//        return entityManagerFactory;
//    }
//}
