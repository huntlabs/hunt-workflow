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
module flow.common.cmd.ReleaseLockCmd;

import flow.common.api.FlowableObjectNotFoundException;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.common.persistence.entity.PropertyEntity;
import flow.common.persistence.entity.PropertyEntityManager;
import hunt.Object;
/**
 * @author Filip Hrisafov
 */
class ReleaseLockCmd : Command!Void {

    protected string lockName;

    this(string lockName) {
        this.lockName = lockName;
    }

    public Void execute(CommandContext commandContext) {

        PropertyEntityManager propertyEntityManager = commandContext.getCurrentEngineConfiguration().getPropertyEntityManager();
        PropertyEntity property = propertyEntityManager.findById(lockName);
        if (property !is null) {
            propertyEntityManager.dele(property);
            return null;
        } else {
            throw new FlowableObjectNotFoundException("Lock with name " ~ lockName ~ " does not exist");
        }
    }
}
