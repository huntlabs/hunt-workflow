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
import org.flowable.job.service.impl.asyncexecutor.AcquireAsyncJobsDueRunnable;
import org.flowable.job.service.impl.asyncexecutor.AsyncExecutor;

/**
 * Extends the default {@link AcquireAsyncJobsDueRunnable} by setting the 'tenant' context before executing.
 * 
 * @author Joram Barrez
 */
class TenantAwareAcquireAsyncJobsDueRunnable extends AcquireAsyncJobsDueRunnable {

    protected TenantInfoHolder tenantInfoHolder;
    protected string tenantId;

    public TenantAwareAcquireAsyncJobsDueRunnable(AsyncExecutor asyncExecutor, TenantInfoHolder tenantInfoHolder, string tenantId) {
        super("flowable-tenant-" + tenantId + "-" + asyncExecutor.getJobServiceConfiguration().getEngineName() + "-acquire-jobs",
                asyncExecutor, asyncExecutor.getJobServiceConfiguration().getJobEntityManager());
        this.tenantInfoHolder = tenantInfoHolder;
        this.tenantId = tenantId;
    }

    protected ExecutorPerTenantAsyncExecutor getTenantAwareAsyncExecutor() {
        return (ExecutorPerTenantAsyncExecutor) asyncExecutor;
    }

    @Override
    public synchronized void run() {
        tenantInfoHolder.setCurrentTenantId(tenantId);
        super.run();
        tenantInfoHolder.clearCurrentTenantId();
    }

}