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
module flow.idm.engine.IdmEngine;


import flow.common.api.Engine;
import flow.common.FlowableVersions;
import flow.idm.api.IdmIdentityService;
import flow.idm.api.IdmManagementService;
import flow.idm.engine.IdmEngineConfiguration;

interface IdmEngine : Engine {

    /**
     * the version of the flowable idm library
     */
    public static string VERSION = "6.5.0.6";

    IdmIdentityService getIdmIdentityService();

    IdmManagementService getIdmManagementService();

    IdmEngineConfiguration getIdmEngineConfiguration();
}
