///* Licensed under the Apache License, Version 2.0 (the "License");
// * you may not use this file except in compliance with the License.
// * You may obtain a copy of the License at
// *
// *      http://www.apache.org/licenses/LICENSE-2.0
// *
// * Unless required by applicable law or agreed to in writing, software
// * distributed under the License is distributed on an "AS IS" BASIS,
// * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// * See the License for the specific language governing permissions and
// * limitations under the License.
// */
//
//
//
//import java.util.Timer;
//import java.util.TimerTask;
//
//import flow.common.api.FlowableException;
//import flow.common.history.HistoryLevel;
//import flow.engine.ManagementService;
//import flow.engine.ProcessEngineConfiguration;
//import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
//import flow.engine.test.FlowableRule;
//import flow.job.service.impl.asyncexecutor.AsyncExecutor;
//
///**
// * @author Tijs Rademakers
// */
//
//class HistoryTestHelper {
//
//    public static bool isHistoryLevelAtLeast(HistoryLevel historyLevel, ProcessEngineConfigurationImpl processEngineConfiguration) {
//        return isHistoryLevelAtLeast(historyLevel, processEngineConfiguration, 10000);
//    }
//
//    public static bool isHistoryLevelAtLeast(HistoryLevel historyLevel, ProcessEngineConfigurationImpl processEngineConfiguration, long time) {
//        if (processEngineConfiguration.getHistoryLevel().isAtLeast(historyLevel)) {
//
//            // When using async history, we need to process all the historic jobs first before the history can be checked
//            if (processEngineConfiguration.isAsyncHistoryEnabled()) {
//                waitForJobExecutorToProcessAllHistoryJobs(processEngineConfiguration, processEngineConfiguration.getManagementService(), time, 200);
//            }
//
//            return true;
//        }
//
//        return false;
//    }
//
//    public static void waitForJobExecutorToProcessAllHistoryJobs(FlowableRule activitiRule, long maxMillisToWait, long intervalMillis) {
//        waitForJobExecutorToProcessAllHistoryJobs(activitiRule.getProcessEngine().getProcessEngineConfiguration(), activitiRule.getManagementService(), maxMillisToWait, intervalMillis);
//    }
//
//    public static void waitForJobExecutorToProcessAllHistoryJobs(ProcessEngineConfiguration processEngineConfiguration, ManagementService managementService,
//            long maxMillisToWait, long intervalMillis) {
//        waitForJobExecutorToProcessAllHistoryJobs(processEngineConfiguration, managementService, maxMillisToWait, intervalMillis, true);
//    }
//
//    public static void waitForJobExecutorToProcessAllHistoryJobs(ProcessEngineConfiguration processEngineConfiguration, ManagementService managementService,
//            long maxMillisToWait, long intervalMillis, bool shutdownExecutorWhenFinished) {
//
//        ProcessEngineConfigurationImpl processEngineConfigurationImpl = (ProcessEngineConfigurationImpl) processEngineConfiguration;
//        if (processEngineConfigurationImpl.isAsyncHistoryEnabled()) {
//            AsyncExecutor asyncHistoryExecutor = processEngineConfiguration.getAsyncHistoryExecutor();
//
//            if (!asyncHistoryExecutor.isActive()) {
//                asyncHistoryExecutor.start();
//            }
//
//            try {
//                Timer timer = new Timer();
//                InterruptTask task = new InterruptTask(Thread.currentThread());
//                timer.schedule(task, maxMillisToWait);
//                bool areJobsAvailable = true;
//                try {
//                    while (areJobsAvailable && !task.isTimeLimitExceeded()) {
//                        Thread.sleep(intervalMillis);
//                        try {
//                            areJobsAvailable = areHistoryJobsAvailable(managementService);
//                        } catch (Throwable t) {
//                            // Ignore, possible that exception occurs due to locking/updating of table on MSSQL when
//                            // isolation level doesn't allow READ of the table
//                        }
//                    }
//                } catch (InterruptedException e) {
//                    // ignore
//                } finally {
//                    timer.cancel();
//                }
//                if (areJobsAvailable) {
//                    throw new FlowableException("time limit of " + maxMillisToWait + " was exceeded");
//                }
//
//            } finally {
//                if (shutdownExecutorWhenFinished) {
//                    asyncHistoryExecutor.shutdown();
//                }
//            }
//        }
//    }
//
//    public static bool areHistoryJobsAvailable(FlowableRule activitiRule) {
//        return areHistoryJobsAvailable(activitiRule.getManagementService());
//
//    }
//
//    public static bool areHistoryJobsAvailable(ManagementService managementService) {
//        return !managementService.createHistoryJobQuery().list().isEmpty();
//    }
//
//    public static bool isHistoricTaskLoggingEnabled(ProcessEngineConfiguration configuration) {
//        ProcessEngineConfigurationImpl processEngineConfiguration = (ProcessEngineConfigurationImpl) configuration;
//        if (processEngineConfiguration.isEnableHistoricTaskLogging()) {
//
//            // When using async history, we need to process all the historic jobs first before the task log history can be checked
//            if (processEngineConfiguration.isAsyncHistoryEnabled()) {
//                waitForJobExecutorToProcessAllHistoryJobs(processEngineConfiguration, processEngineConfiguration.getManagementService(), 10000, 200);
//            }
//
//            return true;
//        }
//
//        return false;
//    }
//
//    private static class InterruptTask : TimerTask {
//
//        protected bool timeLimitExceeded;
//        protected Thread thread;
//
//        public InterruptTask(Thread thread) {
//            this.thread = thread;
//        }
//
//        public bool isTimeLimitExceeded() {
//            return timeLimitExceeded;
//        }
//
//        override
//        public void run() {
//            timeLimitExceeded = true;
//            thread.interrupt();
//        }
//    }
//}
