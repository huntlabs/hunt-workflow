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
module flow.engine.impl.util.EngineServiceUtil;

//import org.flowable.cmmn.api.CmmnEngineConfigurationApi;
//import org.flowable.cmmn.api.CmmnHistoryService;
//import org.flowable.cmmn.api.CmmnManagementService;
//import org.flowable.cmmn.api.CmmnRepositoryService;
//import org.flowable.cmmn.api.CmmnRuntimeService;
import flow.common.AbstractEngineConfiguration;
import flow.common.interceptor.EngineConfigurationConstants;
//import org.flowable.content.api.ContentEngineConfigurationApi;
//import org.flowable.content.api.ContentService;
//import org.flowable.dmn.api.DmnEngineConfigurationApi;
//import org.flowable.dmn.api.DmnManagementService;
//import org.flowable.dmn.api.DmnRepositoryService;
//import org.flowable.dmn.api.DmnRuleService;
import flow.engine.ProcessEngineConfiguration;
import flow.event.registry.api.EventRegistry;
import flow.event.registry.EventRegistryEngineConfiguration;
import flow.form.api.FormEngineConfigurationApi;
import flow.form.api.FormManagementService;
import flow.form.api.FormRepositoryService;
import flow.form.api.FormService;
import flow.idm.api.IdmEngineConfigurationApi;
import flow.idm.api.IdmIdentityService;

class EngineServiceUtil {

    // IDM ENGINE

    public static IdmEngineConfigurationApi getIdmEngineConfiguration(AbstractEngineConfiguration engineConfiguration) {
        return cast(IdmEngineConfigurationApi) engineConfiguration.getEngineConfigurations().get(EngineConfigurationConstants.KEY_IDM_ENGINE_CONFIG);
    }

    public static IdmIdentityService getIdmIdentityService(AbstractEngineConfiguration engineConfiguration) {
        IdmIdentityService idmIdentityService = null;
        IdmEngineConfigurationApi idmEngineConfiguration = getIdmEngineConfiguration(engineConfiguration);
        if (idmEngineConfiguration !is null) {
            idmIdentityService = idmEngineConfiguration.getIdmIdentityService();
        }

        return idmIdentityService;
    }

    // EVENT REGISTRY ENGINE

    public static EventRegistryEngineConfiguration getEventRegistryEngineConfiguration(AbstractEngineConfiguration engineConfiguration) {
        return cast(EventRegistryEngineConfiguration) engineConfiguration.getEngineConfigurations().get(EngineConfigurationConstants.KEY_EVENT_REGISTRY_CONFIG);
    }

    public static EventRegistry getEventRegistry(AbstractEngineConfiguration engineConfiguration) {
        EventRegistry eventRegistry = null;
        EventRegistryEngineConfiguration eventRegistryEngineConfiguration = getEventRegistryEngineConfiguration(engineConfiguration);
        if (eventRegistryEngineConfiguration !is null) {
            eventRegistry = eventRegistryEngineConfiguration.getEventRegistry();
        }

        return eventRegistry;
    }

    // CMMN ENGINE

    //public static CmmnEngineConfigurationApi getCmmnEngineConfiguration(AbstractEngineConfiguration engineConfiguration) {
    //    return (CmmnEngineConfigurationApi) engineConfiguration.getEngineConfigurations().get(EngineConfigurationConstants.KEY_CMMN_ENGINE_CONFIG);
    //}
    //
    //public static CmmnRepositoryService getCmmnRepositoryService(AbstractEngineConfiguration engineConfiguration) {
    //    CmmnRepositoryService cmmnRepositoryService = null;
    //    CmmnEngineConfigurationApi cmmnEngineConfiguration = getCmmnEngineConfiguration(engineConfiguration);
    //    if (cmmnEngineConfiguration !is null) {
    //        cmmnRepositoryService = cmmnEngineConfiguration.getCmmnRepositoryService();
    //    }
    //
    //    return cmmnRepositoryService;
    //}
    //
    //public static CmmnRuntimeService getCmmnRuntimeService(AbstractEngineConfiguration engineConfiguration) {
    //    CmmnRuntimeService cmmnRuntimeService = null;
    //    CmmnEngineConfigurationApi cmmnEngineConfiguration = getCmmnEngineConfiguration(engineConfiguration);
    //    if (cmmnEngineConfiguration !is null) {
    //        cmmnRuntimeService = cmmnEngineConfiguration.getCmmnRuntimeService();
    //    }
    //
    //    return cmmnRuntimeService;
    //}
    //
    //public static CmmnHistoryService getCmmnHistoryService(AbstractEngineConfiguration engineConfiguration) {
    //    CmmnHistoryService cmmnHistoryService = null;
    //    CmmnEngineConfigurationApi cmmnEngineConfiguration = getCmmnEngineConfiguration(engineConfiguration);
    //    if (cmmnEngineConfiguration !is null) {
    //        cmmnHistoryService = cmmnEngineConfiguration.getCmmnHistoryService();
    //    }
    //
    //    return cmmnHistoryService;
    //}
    //
    //public static CmmnManagementService getCmmnManagementService(AbstractEngineConfiguration engineConfiguration) {
    //    CmmnManagementService cmmnManagementService = null;
    //    CmmnEngineConfigurationApi cmmnEngineConfiguration = getCmmnEngineConfiguration(engineConfiguration);
    //    if (cmmnEngineConfiguration !is null) {
    //        cmmnManagementService = cmmnEngineConfiguration.getCmmnManagementService();
    //    }
    //
    //    return cmmnManagementService;
    //}
    //
    //// DMN ENGINE
    //
    //public static DmnEngineConfigurationApi getDmnEngineConfiguration(AbstractEngineConfiguration engineConfiguration) {
    //    return (DmnEngineConfigurationApi) engineConfiguration.getEngineConfigurations().get(EngineConfigurationConstants.KEY_DMN_ENGINE_CONFIG);
    //}
    //
    //public static DmnRepositoryService getDmnRepositoryService(AbstractEngineConfiguration engineConfiguration) {
    //    DmnRepositoryService dmnRepositoryService = null;
    //    DmnEngineConfigurationApi dmnEngineConfiguration = getDmnEngineConfiguration(engineConfiguration);
    //    if (dmnEngineConfiguration !is null) {
    //        dmnRepositoryService = dmnEngineConfiguration.getDmnRepositoryService();
    //    }
    //
    //    return dmnRepositoryService;
    //}
    //
    //public static DmnRuleService getDmnRuleService(AbstractEngineConfiguration engineConfiguration) {
    //    DmnRuleService dmnRuleService = null;
    //    DmnEngineConfigurationApi dmnEngineConfiguration = getDmnEngineConfiguration(engineConfiguration);
    //    if (dmnEngineConfiguration !is null) {
    //        dmnRuleService = dmnEngineConfiguration.getDmnRuleService();
    //    }
    //
    //    return dmnRuleService;
    //}
    //
    //public static DmnManagementService getDmnManagementService(AbstractEngineConfiguration engineConfiguration) {
    //    DmnManagementService dmnManagementService = null;
    //    DmnEngineConfigurationApi dmnEngineConfiguration = getDmnEngineConfiguration(engineConfiguration);
    //    if (dmnEngineConfiguration !is null) {
    //        dmnManagementService = dmnEngineConfiguration.getDmnManagementService();
    //    }
    //
    //    return dmnManagementService;
    //}

    // FORM ENGINE

    public static FormEngineConfigurationApi getFormEngineConfiguration(AbstractEngineConfiguration engineConfiguration) {
        return cast(FormEngineConfigurationApi) engineConfiguration.getEngineConfigurations().get(EngineConfigurationConstants.KEY_FORM_ENGINE_CONFIG);
    }

    public static FormRepositoryService getFormRepositoryService(ProcessEngineConfiguration processEngineConfiguration) {
        FormRepositoryService formRepositoryService = null;
        FormEngineConfigurationApi formEngineConfiguration = getFormEngineConfiguration(processEngineConfiguration);
        if (formEngineConfiguration !is null) {
            formRepositoryService = formEngineConfiguration.getFormRepositoryService();
        }

        return formRepositoryService;
    }

    public static FormService getFormService(AbstractEngineConfiguration engineConfiguration) {
        FormService formService = null;
        FormEngineConfigurationApi formEngineConfiguration = getFormEngineConfiguration(engineConfiguration);
        if (formEngineConfiguration !is null) {
            formService = formEngineConfiguration.getFormService();
        }

        return formService;
    }

    public static FormManagementService getFormManagementService(AbstractEngineConfiguration engineConfiguration) {
        FormManagementService formManagementService = null;
        FormEngineConfigurationApi formEngineConfiguration = getFormEngineConfiguration(engineConfiguration);
        if (formEngineConfiguration !is null) {
            formManagementService = formEngineConfiguration.getFormManagementService();
        }

        return formManagementService;
    }

    // CONTENT ENGINE

    //public static ContentEngineConfigurationApi getContentEngineConfiguration(AbstractEngineConfiguration engineConfiguration) {
    //    return (ContentEngineConfigurationApi) engineConfiguration.getEngineConfigurations().get(EngineConfigurationConstants.KEY_CONTENT_ENGINE_CONFIG);
    //}
    //
    //public static ContentService getContentService(AbstractEngineConfiguration engineConfiguration) {
    //    ContentService contentService = null;
    //    ContentEngineConfigurationApi contentEngineConfiguration = getContentEngineConfiguration(engineConfiguration);
    //    if (contentEngineConfiguration !is null) {
    //        contentService = contentEngineConfiguration.getContentService();
    //    }
    //
    //    return contentService;
    //}

}
