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

module flow.idm.engine.impl.cmd.GetUserInfoCmd;


import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.idm.engine.impl.persistence.entity.IdentityInfoEntity;
import flow.idm.engine.impl.util.CommandContextUtil;
import hunt.Exceptions;
/**
 * @author Tom Baeyens
 */
class GetUserInfoCmd : Command!string {

    protected string userId;
    protected string key;

    this(string userId, string key) {
        this.userId = userId;
        this.key = key;
    }

    public string execute(CommandContext commandContext) {
        implementationMissing(false);
        return "";
        //IdentityInfoEntity identityInfo = CommandContextUtil.getIdentityInfoEntityManager(commandContext).findUserInfoByUserIdAndKey(userId, key);
        //
        //return (identityInfo !is null ? identityInfo.getValue() : null);
    }
}
