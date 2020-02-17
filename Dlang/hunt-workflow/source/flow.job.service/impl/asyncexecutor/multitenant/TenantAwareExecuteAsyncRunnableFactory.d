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
import org.flowable.job.api.JobInfo;
import org.flowable.job.service.JobServiceConfiguration;
import org.flowable.job.service.impl.asyncexecutor.ExecuteAsyncRunnableFactory;
import org.flowable.job.service.impl.persistence.entity.JobEntity;

/**
 * Factory that produces a {@link Runnable} that executes a {@link JobEntity}. Can be used to create special implementations for specific tenants.
 * 
 * @author Joram Barrez
 */
class TenantAwareExecuteAsyncRunnableFactory implements ExecuteAsyncRunnableFactory {

    protected TenantInfoHolder tenantInfoHolder;
    protected string tenantId;

    public TenantAwareExecuteAsyncRunnableFactory(TenantInfoHolder tenantInfoHolder, string tenantId) {
        this.tenantInfoHolder = tenantInfoHolder;
        this.tenantId = tenantId;
    }

    @Override
    public Runnable createExecuteAsyncRunnable(JobInfo job, JobServiceConfiguration jobServiceConfiguration) {
        return new TenantAwareExecuteAsyncRunnable(job, jobServiceConfiguration, tenantInfoHolder, tenantId);
    }

}
