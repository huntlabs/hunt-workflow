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
module flow.idm.engine.impl.cmd.UpdateUserPasswordCmd;


import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.idm.api.PasswordEncoder;
import flow.idm.api.PasswordSalt;
import flow.idm.api.User;
import flow.idm.engine.impl.util.CommandContextUtil;
import hunt.Exceptions;
/**
 * @author faizal-manan
 */
class UpdateUserPasswordCmd : Command!User {

    private User user;

    this(User user) {
        this.user = user;
    }

    public User execute(CommandContext commandContext) {
        implementationMissing(false);
        return null;
        //if (!CommandContextUtil.getUserEntityManager(commandContext).isNewUser(user)) {
        //    PasswordEncoder passwordEncoder = CommandContextUtil.getIdmEngineConfiguration().getPasswordEncoder();
        //    PasswordSalt passwordSalt = CommandContextUtil.getIdmEngineConfiguration().getPasswordSalt();
        //
        //    user.setPassword(passwordEncoder.encode(user.getPassword(), passwordSalt));
        //    CommandContextUtil.getUserEntityManager(commandContext).updateUser(user);
        //}
        //return user;
    }
}
