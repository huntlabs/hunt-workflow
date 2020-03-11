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

module flow.idm.engine.impl.cmd.SetUserInfoCmd;

import hunt.collection.Map;

import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.idm.engine.impl.persistence.entity.IdentityInfoEntity;
import flow.idm.engine.impl.util.CommandContextUtil;
import hunt.Exceptions;
/**
 * @author Tom Baeyens
 */
class SetUserInfoCmd : Command!Object {

    protected string userId;
    protected string userPassword;
    protected string type;
    protected string key;
    protected string value;
    protected string accountPassword;
    protected Map!(string, string) accountDetails;

    this(string userId, string key, string value) {
        this.userId = userId;
        this.type = IdentityInfoEntity.TYPE_USERINFO;
        this.key = key;
        this.value = value;
    }

    public Object execute(CommandContext commandContext) {
        implementationMissing(false);
       // CommandContextUtil.getIdentityInfoEntityManager(commandContext).updateUserInfo(userId, userPassword, type, key, value, accountPassword, accountDetails);
        return null;
    }
}
