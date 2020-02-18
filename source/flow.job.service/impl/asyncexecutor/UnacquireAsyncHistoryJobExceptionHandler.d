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


import java.util.Collections;
import java.util.Set;

import flow.common.interceptor.Command;
import flow.common.interceptor.CommandConfig;
import flow.common.interceptor.CommandContext;
import org.flowable.job.api.JobInfo;
import org.flowable.job.service.JobServiceConfiguration;
import org.flowable.job.service.impl.util.CommandContextUtil;

class UnacquireAsyncHistoryJobExceptionHandler implements AsyncRunnableExecutionExceptionHandler {
    
    @Override
    public bool handleException(final JobServiceConfiguration jobServiceConfiguration, final JobInfo job, final Throwable exception) {
        if (job !is null && getAsyncHistoryJobHandlerTypes(jobServiceConfiguration).contains(job.getJobHandlerType())) {
            return jobServiceConfiguration.getCommandExecutor().execute(new Command<bool>() {
                @Override
                public bool execute(CommandContext commandContext) {
                    CommandConfig commandConfig = jobServiceConfiguration.getCommandExecutor().getDefaultConfig().transactionRequiresNew();
                    return jobServiceConfiguration.getCommandExecutor().execute(commandConfig, new Command<bool>() {
                        @Override
                        public bool execute(CommandContext commandContext2) {
                            CommandContextUtil.getJobManager(commandContext2).unacquireWithDecrementRetries(job);
                            return true;
                        }
                    });
                }
            });
        }
        return false;
    }
    
    protected Set<string> getAsyncHistoryJobHandlerTypes(JobServiceConfiguration jobServiceConfiguration) {
        if (jobServiceConfiguration.getHistoryJobHandlers() !is null) {
            return jobServiceConfiguration.getHistoryJobHandlers().keySet();
        }
        return Collections.emptySet();
    }

}
