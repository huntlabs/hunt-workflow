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
//import flow.common.test.EnsureCleanDb;
//import flow.idm.api.IdmIdentityService;
//import flow.idm.api.IdmManagementService;
//import flow.idm.engine.IdmEngine;
//import flow.idm.engine.IdmEngineConfiguration;
//import org.junit.jupiter.api.BeforeEach;
//
///**
// * @author Tijs Rademakers
// * @author Joram Barrez
// */
//@EnsureCleanDb(excludeTables = {
//    "ACT_ID_PROPERTY",
//    "ACT_GE_PROPERTY"
//})
//public abstract class AbstractFlowableIdmTestCase extends AbstractTestCase {
//
//    protected IdmEngine idmEngine;
//
//    protected IdmEngineConfiguration idmEngineConfiguration;
//    protected IdmIdentityService idmIdentityService;
//    protected IdmManagementService idmManagementService;
//
//    @BeforeEach
//    protected void initializeServices(IdmEngine idmEngine) {
//        this.idmEngine = idmEngine;
//        idmEngineConfiguration = idmEngine.getIdmEngineConfiguration();
//        idmIdentityService = idmEngine.getIdmIdentityService();
//        idmManagementService = idmEngine.getIdmManagementService();
//    }
//
//}
