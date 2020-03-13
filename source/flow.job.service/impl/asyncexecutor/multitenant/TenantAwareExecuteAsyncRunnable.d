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



import flow.common.cfg.multitenant.TenantInfoHolder;
import flow.job.service.api.JobInfo;
import flow.job.service.JobServiceConfiguration;
import flow.job.service.impl.asyncexecutor.ExecuteAsyncRunnable;

/**
 * Extends the default {@link ExecuteAsyncRunnable} by setting the 'tenant' context before executing.
 *
 * @author Joram Barrez
 */
class TenantAwareExecuteAsyncRunnable extends ExecuteAsyncRunnable {

    protected TenantInfoHolder tenantInfoHolder;
    protected string tenantId;

    public TenantAwareExecuteAsyncRunnable(JobInfo job, JobServiceConfiguration jobServiceConfiguration, TenantInfoHolder tenantInfoHolder, string tenantId) {
        super(job, jobServiceConfiguration, jobServiceConfiguration.getJobEntityManager(), null);
        this.tenantInfoHolder = tenantInfoHolder;
        this.tenantId = tenantId;
    }

    @Override
    public void run() {
        tenantInfoHolder.setCurrentTenantId(tenantId);
        super.run();
        tenantInfoHolder.clearCurrentTenantId();
    }

}
