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
//          Copyright linse 2020.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)}

module flow.common.interceptor.EngineConfigurationConstants;





interface EngineConfigurationConstants {

    static string KEY_PROCESS_ENGINE_CONFIG = "cfg.processEngine";

  static string KEY_DMN_ENGINE_CONFIG = "cfg.dmnEngine";

  static string KEY_IDM_ENGINE_CONFIG = "cfg.idmEngine";

  static string KEY_FORM_ENGINE_CONFIG = "cfg.formEngine";

  static string KEY_CONTENT_ENGINE_CONFIG = "cfg.contentEngine";

  static string KEY_CMMN_ENGINE_CONFIG = "cfg.cmmnEngine";

  static string KEY_APP_ENGINE_CONFIG = "cfg.appEngine";

  static string KEY_EVENT_REGISTRY_CONFIG = "cfg.eventRegistry";

  static string KEY_TASK_SERVICE_CONFIG = "cfg.taskService";

  static string KEY_VARIABLE_SERVICE_CONFIG = "cfg.variableService";

  static string KEY_IDENTITY_LINK_SERVICE_CONFIG = "cfg.identityLinkService";

  static  string KEY_ENTITY_LINK_SERVICE_CONFIG = "cfg.entityLinkService";

  static string KEY_EVENT_SUBSCRIPTION_SERVICE_CONFIG = "cfg.eventSubscriptionService";

  static string KEY_JOB_SERVICE_CONFIG = "cfg.jobService";

  static string KEY_BATCH_SERVICE_CONFIG = "cfg.batchService";

  static int PRIORITY_ENGINE_PROCESS = 50000;

  static int PRIORITY_ENGINE_EVENT_REGISTRY = 100000;

  static  int PRIORITY_ENGINE_IDM = 150000;

  static int PRIORITY_ENGINE_DMN = 200000;

  static int PRIORITY_ENGINE_FORM = 300000;

  static  int PRIORITY_ENGINE_CONTENT = 400000;

  static int PRIORITY_ENGINE_CMMN = 500000;

}
