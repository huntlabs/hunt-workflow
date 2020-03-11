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
module flow.idm.engine.impl.cmd.DeleteTokenCmd;


import flow.common.api.FlowableIllegalArgumentException;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.idm.engine.impl.util.CommandContextUtil;
import hunt.Object;
import hunt.Exceptions;
/**
 * @author Tijs Rademakers
 */
class DeleteTokenCmd : Command!Void {

    string tokenId;

    this(string tokenId) {
        this.tokenId = tokenId;
    }

    public Void execute(CommandContext commandContext) {
        //if (tokenId is null) {
        //    throw new FlowableIllegalArgumentException("tokenId is null");
        //}
        //CommandContextUtil.getTokenEntityManager(commandContext).delete(tokenId);
        implementationMissing(false);
        return null;
    }
}
