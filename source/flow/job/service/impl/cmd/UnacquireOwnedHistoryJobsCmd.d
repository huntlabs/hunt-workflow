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
module flow.job.service.impl.cmd.UnacquireOwnedHistoryJobsCmd;

import hunt.collection.List;

import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.job.service.api.HistoryJob;
import flow.job.service.impl.HistoryJobQueryImpl;
import flow.job.service.impl.util.CommandContextUtil;
import hunt.Object;


class UnacquireOwnedHistoryJobsCmd : Command!Void {

    private  string lockOwner;
    private  string tenantId;

    this(string lockOwner, string tenantId) {
        this.lockOwner = lockOwner;
        this.tenantId = tenantId;
    }

    public Void execute(CommandContext commandContext) {
        HistoryJobQueryImpl jobQuery = new HistoryJobQueryImpl(commandContext);
        jobQuery.lockOwner(lockOwner);
        jobQuery.jobTenantId(tenantId);
        List!HistoryJob jobs = CommandContextUtil.getHistoryJobEntityManager(commandContext).findHistoryJobsByQueryCriteria(jobQuery);
        foreach (HistoryJob job ; jobs) {
            CommandContextUtil.getJobManager(commandContext).unacquire(job);
        }
        return null;
    }
}
