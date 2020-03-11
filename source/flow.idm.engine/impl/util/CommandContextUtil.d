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

module flow.idm.engine.impl.util.CommandContextUtil;

import flow.common.context.Context;
import flow.common.db.DbSqlSession;
import flow.common.interceptor.CommandContext;
import flow.common.interceptor.EngineConfigurationConstants;
import flow.idm.engine.IdmEngineConfiguration;
import flow.idm.engine.impl.persistence.entity.ByteArrayEntityManager;
import flow.idm.engine.impl.persistence.entity.GroupEntityManager;
import flow.idm.engine.impl.persistence.entity.IdentityInfoEntityManager;
import flow.idm.engine.impl.persistence.entity.MembershipEntityManager;
import flow.idm.engine.impl.persistence.entity.PrivilegeEntityManager;
import flow.idm.engine.impl.persistence.entity.PrivilegeMappingEntityManager;
import flow.idm.engine.impl.persistence.entity.PropertyEntityManager;
import flow.idm.engine.impl.persistence.entity.TableDataManager;
import flow.idm.engine.impl.persistence.entity.TokenEntityManager;
import flow.idm.engine.impl.persistence.entity.UserEntityManager;

class CommandContextUtil {

    public static IdmEngineConfiguration getIdmEngineConfiguration() {
        return getIdmEngineConfiguration(getCommandContext());
    }

    public static IdmEngineConfiguration getIdmEngineConfiguration(CommandContext commandContext) {
        if (commandContext !is null) {
            return cast(IdmEngineConfiguration) commandContext.getEngineConfigurations().get(EngineConfigurationConstants.KEY_IDM_ENGINE_CONFIG);
        }
        return null;
    }

    //public static DbSqlSession getDbSqlSession() {
    //    return getDbSqlSession(getCommandContext());
    //}
    //
    //public static DbSqlSession getDbSqlSession(CommandContext commandContext) {
    //    return commandContext.getSession(DbSqlSession.class);
    //}

    public static TableDataManager getTableDataManager() {
        return getTableDataManager(getCommandContext());
    }

    public static TableDataManager getTableDataManager(CommandContext commandContext) {
        return getIdmEngineConfiguration(commandContext).getTableDataManager();
    }

    public static ByteArrayEntityManager getByteArrayEntityManager() {
        return getByteArrayEntityManager(getCommandContext());
    }

    public static ByteArrayEntityManager getByteArrayEntityManager(CommandContext commandContext) {
        return getIdmEngineConfiguration(commandContext).getByteArrayEntityManager();
    }

    public static PropertyEntityManager getPropertyEntityManager() {
        return getPropertyEntityManager(getCommandContext());
    }

    public static PropertyEntityManager getPropertyEntityManager(CommandContext commandContext) {
        return getIdmEngineConfiguration(commandContext).getIdmPropertyEntityManager();
    }

    public static UserEntityManager getUserEntityManager() {
        return getUserEntityManager(getCommandContext());
    }

    public static UserEntityManager getUserEntityManager(CommandContext commandContext) {
        return getIdmEngineConfiguration(commandContext).getUserEntityManager();
    }

    public static GroupEntityManager getGroupEntityManager() {
        return getGroupEntityManager(getCommandContext());
    }

    public static GroupEntityManager getGroupEntityManager(CommandContext commandContext) {
        return getIdmEngineConfiguration(commandContext).getGroupEntityManager();
    }

    public static MembershipEntityManager getMembershipEntityManager() {
        return getMembershipEntityManager(getCommandContext());
    }

    public static MembershipEntityManager getMembershipEntityManager(CommandContext commandContext) {
        return getIdmEngineConfiguration(commandContext).getMembershipEntityManager();
    }

    public static PrivilegeEntityManager getPrivilegeEntityManager() {
        return getPrivilegeEntityManager(getCommandContext());
    }

    public static PrivilegeEntityManager getPrivilegeEntityManager(CommandContext commandContext) {
        return getIdmEngineConfiguration(commandContext).getPrivilegeEntityManager();
    }

    public static PrivilegeMappingEntityManager getPrivilegeMappingEntityManager() {
        return getPrivilegeMappingEntityManager(getCommandContext());
    }

    public static PrivilegeMappingEntityManager getPrivilegeMappingEntityManager(CommandContext commandContext) {
        return getIdmEngineConfiguration(commandContext).getPrivilegeMappingEntityManager();
    }

    public static TokenEntityManager getTokenEntityManager() {
        return getTokenEntityManager(getCommandContext());
    }

    public static TokenEntityManager getTokenEntityManager(CommandContext commandContext) {
        return getIdmEngineConfiguration(commandContext).getTokenEntityManager();
    }

    public static IdentityInfoEntityManager getIdentityInfoEntityManager() {
        return getIdentityInfoEntityManager(getCommandContext());
    }

    public static IdentityInfoEntityManager getIdentityInfoEntityManager(CommandContext commandContext) {
        return getIdmEngineConfiguration(commandContext).getIdentityInfoEntityManager();
    }

    public static CommandContext getCommandContext() {
        return Context.getCommandContext();
    }

}
