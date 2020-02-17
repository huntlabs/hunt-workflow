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

//          Copyright linse 2020. 
// Distributed under the Boost Software License, Version 1.0. 
//    (See accompanying file LICENSE_1_0.txt or copy at 
//          http://www.boost.org/LICENSE_1_0.txt)} 
 
module flow.common.interceptor.RetryInterceptor;
 
 
//
//
//
//import flow.common.api.FlowableException;
//import flow.common.api.FlowableOptimisticLockingException;
//
///**
// * Intercepts {@link FlowableOptimisticLockingException} and tries to run the same command again. The number of retries and the time waited between retries is configurable.
// *
// * @author Daniel Meyer
// */
//class RetryInterceptor : AbstractCommandInterceptor {
//
//    protected int numOfRetries = 3;
//    protected int waitTimeInMs = 50;
//    protected int waitIncreaseFactor = 5;
//
//    @Override
//    public <T> T execute(CommandConfig config, Command<T> command) {
//        long waitTime = waitTimeInMs;
//        int failedAttempts = 0;
//
//        do {
//            if (failedAttempts > 0) {
//                LOGGER.info("Waiting for {}ms before retrying the command.", waitTime);
//                waitBeforeRetry(waitTime);
//                waitTime *= waitIncreaseFactor;
//            }
//
//            try {
//
//                // try to execute the command
//                return next.execute(config, command);
//
//            } catch (FlowableOptimisticLockingException e) {
//                LOGGER.info("Caught optimistic locking exception: {}", e.getMessage(), e);
//            }
//
//            failedAttempts++;
//        } while (failedAttempts <= numOfRetries);
//
//        throw new FlowableException(numOfRetries + " retries failed with FlowableOptimisticLockingException. Giving up.");
//    }
//
//    protected void waitBeforeRetry(long waitTime) {
//        try {
//            Thread.sleep(waitTime);
//        } catch (InterruptedException e) {
//            LOGGER.debug("I am interrupted while waiting for a retry.");
//        }
//    }
//
//    public void setNumOfRetries(int numOfRetries) {
//        this.numOfRetries = numOfRetries;
//    }
//
//    public void setWaitIncreaseFactor(int waitIncreaseFactor) {
//        this.waitIncreaseFactor = waitIncreaseFactor;
//    }
//
//    public void setWaitTimeInMs(int waitTimeInMs) {
//        this.waitTimeInMs = waitTimeInMs;
//    }
//
//    public int getNumOfRetries() {
//        return numOfRetries;
//    }
//
//    public int getWaitIncreaseFactor() {
//        return waitIncreaseFactor;
//    }
//
//    public int getWaitTimeInMs() {
//        return waitTimeInMs;
//    }
//}
