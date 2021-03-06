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
//module flow.job.service.impl.asyncexecutor.DefaultAsyncHistoryJobExecutor;
//import flow.job.service.impl.asyncexecutor.DefaultAsyncJobExecutor;
//
//class DefaultAsyncHistoryJobExecutor : DefaultAsyncJobExecutor {
//
//    this() {
//        setTimerRunnableNeeded(false);
//        setAcquireRunnableThreadName("flowable-acquire-history-jobs");
//        setResetExpiredRunnableName("flowable-reset-expired-history-jobs");
//        setThreadPoolNamingPattern("flowable-async-history-job-executor-thread-%d");
//        setAsyncRunnableExecutionExceptionHandler(new UnacquireAsyncHistoryJobExceptionHandler());
//    }
//
//    @Override
//    protected void initializeJobEntityManager() {
//        if (jobEntityManager is null) {
//            jobEntityManager = jobServiceConfiguration.getHistoryJobEntityManager();
//        }
//    }
//
//}
