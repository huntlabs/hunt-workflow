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

module flow.job.service.impl.ServiceImpl;

import flow.common.api.deleg.event.FlowableEventDispatcher;
import flow.common.interceptor.CommandExecutor;
import flow.common.service.CommonServiceImpl;
import flow.job.service.JobServiceConfiguration;
import flow.job.service.impl.asyncexecutor.JobManager;
import flow.job.service.impl.persistence.entity.DeadLetterJobEntityManager;
import flow.job.service.impl.persistence.entity.HistoryJobEntityManager;
import flow.job.service.impl.persistence.entity.JobEntityManager;
import flow.job.service.impl.persistence.entity.SuspendedJobEntityManager;
import flow.job.service.impl.persistence.entity.TimerJobEntityManager;

/**
 * @author Tijs Rademakers
 */
class ServiceImpl : CommonServiceImpl!JobServiceConfiguration {

    this() {

    }

    this(JobServiceConfiguration configuration) {
        super(configuration);
    }

    public FlowableEventDispatcher getEventDispatcher() {
        return configuration.getEventDispatcher();
    }

    public JobManager getJobManager() {
        return configuration.getJobManager();
    }

    public JobEntityManager getJobEntityManager() {
        return configuration.getJobEntityManager();
    }

    public DeadLetterJobEntityManager getDeadLetterJobEntityManager() {
        return configuration.getDeadLetterJobEntityManager();
    }

    public SuspendedJobEntityManager getSuspendedJobEntityManager() {
        return configuration.getSuspendedJobEntityManager();
    }

    public TimerJobEntityManager getTimerJobEntityManager() {
        return configuration.getTimerJobEntityManager();
    }

    public HistoryJobEntityManager getHistoryJobEntityManager() {
        return configuration.getHistoryJobEntityManager();
    }

    public CommandExecutor getCommandExecutor() {
        return configuration.getCommandExecutor();
    }
}
