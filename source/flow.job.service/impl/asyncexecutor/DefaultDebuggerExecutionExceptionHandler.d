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
module flow.job.service.impl.asyncexecutor.DefaultDebuggerExecutionExceptionHandler;

import flow.job.service.api.JobInfo;
import flow.job.service.JobServiceConfiguration;
import flow.job.service.impl.persistence.entity.JobEntity;
import flow.job.service.impl.persistence.entity.SuspendedJobEntity;
import flow.job.service.impl.asyncexecutor.AsyncRunnableExecutionExceptionHandler;
import hunt.Exceptions;
import hunt.logging;
/**
 * Swallow exception for the debugger executions and add debugger breakpoint again to the suspended jobs.
 *
 * @author martin.grofcik
 */
class DefaultDebuggerExecutionExceptionHandler : AsyncRunnableExecutionExceptionHandler {

    private static  string HANDLER_TYPE_BREAK_POINT = "breakpoint";

    public bool handleException( JobServiceConfiguration jobServiceConfiguration,  JobInfo job,  Throwable exception) {
        implementationMissing(false);
        return true;
        //if (HANDLER_TYPE_BREAK_POINT == (job.getJobHandlerType())) {
        //    LOGGER.debug("break point execution throws an exception which will be swallowed", exception);
        //    jobServiceConfiguration.getCommandExecutor().execute(
        //            commandContext -> {
        //                JobEntity jobEntity = jobServiceConfiguration.getJobService().findJobById(job.getId());
        //                SuspendedJobEntity suspendedJobEntity = jobServiceConfiguration.getJobService().moveJobToSuspendedJob(jobEntity);
        //                if (exception !is null) {
        //                    LOGGER.info("Debugger exception ", exception);
        //                    suspendedJobEntity.setExceptionMessage(exception.getMessage());
        //                    suspendedJobEntity.setExceptionStacktrace(ExceptionUtils.getStackTrace(exception));
        //                }
        //                return null;
        //            }
        //    );
        //    return true;
        //}
        //return false;
    }

}
