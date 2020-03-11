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
module flow.idm.engine.impl.cmd.SaveUserCmd;


import flow.common.api.FlowableIllegalArgumentException;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.common.persistence.entity.Entity;
import flow.idm.api.PasswordEncoder;
import flow.idm.api.PasswordSalt;
import flow.idm.api.User;
import flow.idm.engine.impl.persistence.entity.UserEntity;
import flow.idm.engine.impl.util.CommandContextUtil;
import hunt.Object;
import hunt.Exceptions;
/**
 * @author Joram Barrez
 */
class SaveUserCmd : Command!Void {

    protected User user;

    this(User user) {
        this.user = user;
    }

    public Void execute(CommandContext commandContext) {
        implementationMissing(false);
        //if (user is null) {
        //    throw new FlowableIllegalArgumentException("user is null");
        //}
        //
        //if (CommandContextUtil.getUserEntityManager(commandContext).isNewUser(user)) {
        //    if (user.getPassword() !is null) {
        //        PasswordEncoder passwordEncoder = CommandContextUtil.getIdmEngineConfiguration().getPasswordEncoder();
        //        PasswordSalt passwordSalt = CommandContextUtil.getIdmEngineConfiguration().getPasswordSalt();
        //        user.setPassword(passwordEncoder.encode(user.getPassword(), passwordSalt));
        //    }
        //
        //    if (user instanceof UserEntity) {
        //        CommandContextUtil.getUserEntityManager(commandContext).insert((UserEntity) user, true);
        //    } else {
        //        CommandContextUtil.getDbSqlSession(commandContext).insert((Entity) user);
        //    }
        //} else {
        //    UserEntity dbUser = CommandContextUtil.getUserEntityManager().findById(user.getId());
        //    user.setPassword(dbUser.getPassword());
        //    CommandContextUtil.getUserEntityManager().updateUser(user);
        //}

        return null;
    }
}
