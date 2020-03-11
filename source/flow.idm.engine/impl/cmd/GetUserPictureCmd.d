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

module flow.idm.engine.impl.cmd.GetUserPictureCmd;


import flow.common.api.FlowableIllegalArgumentException;
import flow.common.api.FlowableObjectNotFoundException;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.idm.api.Picture;
import flow.idm.api.User;
import flow.idm.engine.impl.util.CommandContextUtil;
import hunt.Exceptions;
/**
 * @author Tom Baeyens
 */
class GetUserPictureCmd : Command!Picture {

    protected string userId;

    this(string userId) {
        this.userId = userId;
    }

    public Picture execute(CommandContext commandContext) {
        implementationMissing(false);
        return null;
        //if (userId is null) {
        //    throw new FlowableIllegalArgumentException("userId is null");
        //}
        //
        //User user = CommandContextUtil.getIdmEngineConfiguration().getIdmIdentityService()
        //        .createUserQuery().userId(userId)
        //        .singleResult();
        //
        //if (user is null) {
        //    throw new FlowableObjectNotFoundException("user " + userId + " doesn't exist", User.class);
        //}
        //
        //return CommandContextUtil.getUserEntityManager(commandContext).getUserPicture(user);
    }

}
