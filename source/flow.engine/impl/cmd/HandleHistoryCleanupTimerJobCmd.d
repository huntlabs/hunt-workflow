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



import java.io.Serializable;
import hunt.collection.List;

import flow.common.calendar.BusinessCalendar;
import flow.common.calendar.CycleBusinessCalendar;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.engine.ManagementService;
import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
import flow.engine.impl.jobexecutor.BpmnHistoryCleanupJobHandler;
import flow.engine.impl.util.CommandContextUtil;
import flow.job.service.api.Job;
import flow.job.service.TimerJobService;
import flow.job.service.impl.persistence.entity.JobEntity;
import flow.job.service.impl.persistence.entity.TimerJobEntity;

class HandleHistoryCleanupTimerJobCmd implements Command!Object, Serializable {

    private static final long serialVersionUID = 1L;

    override
    public Object execute(CommandContext commandContext) {
        ProcessEngineConfigurationImpl processEngineConfiguration = CommandContextUtil.getProcessEngineConfiguration(commandContext);
        ManagementService managementService = processEngineConfiguration.getManagementService();
        TimerJobService timerJobService = CommandContextUtil.getTimerJobService(commandContext);
        List!Job cleanupJobs = managementService.createTimerJobQuery().handlerType(BpmnHistoryCleanupJobHandler.TYPE).list();

        if (cleanupJobs.isEmpty()) {
            TimerJobEntity timerJob = timerJobService.createTimerJob();
            timerJob.setJobType(JobEntity.JOB_TYPE_TIMER);
            timerJob.setRevision(1);
            timerJob.setJobHandlerType(BpmnHistoryCleanupJobHandler.TYPE);

            BusinessCalendar businessCalendar = processEngineConfiguration.getBusinessCalendarManager().getBusinessCalendar(CycleBusinessCalendar.NAME);
            timerJob.setDuedate(businessCalendar.resolveDuedate(processEngineConfiguration.getHistoryCleaningTimeCycleConfig()));
            timerJob.setRepeat(processEngineConfiguration.getHistoryCleaningTimeCycleConfig());

            timerJobService.scheduleTimerJob(timerJob);

        } else {
            if (cleanupJobs.size() > 1) {
                for (int i = 1; i < cleanupJobs.size(); i++) {
                    managementService.deleteTimerJob(cleanupJobs.get(i).getId());
                }
            }
        }

        return null;
    }

}
