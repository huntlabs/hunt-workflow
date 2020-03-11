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
module flow.idm.engine.impl.cmd.SaveTokenCmd;


import flow.common.api.FlowableIllegalArgumentException;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.common.persistence.entity.Entity;
import flow.idm.api.Token;
import flow.idm.engine.impl.persistence.entity.TokenEntity;
import flow.idm.engine.impl.util.CommandContextUtil;
import hunt.Object;
import hunt.Exceptions;
/**
 * @author Tijs Rademakers
 */
class SaveTokenCmd : Command!Void {

    protected Token token;

    this(Token token) {
        this.token = token;
    }

    public Void execute(CommandContext commandContext) {
        implementationMissing(false);
        //if (token is null) {
        //    throw new FlowableIllegalArgumentException("token is null");
        //}
        //
        //if (CommandContextUtil.getTokenEntityManager(commandContext).isNewToken(token)) {
        //    if (token instanceof TokenEntity) {
        //        CommandContextUtil.getTokenEntityManager(commandContext).insert((TokenEntity) token, true);
        //    } else {
        //        CommandContextUtil.getDbSqlSession(commandContext).insert((Entity) token);
        //    }
        //} else {
        //    CommandContextUtil.getTokenEntityManager(commandContext).updateToken(token);
        //}

        return null;
    }
}
