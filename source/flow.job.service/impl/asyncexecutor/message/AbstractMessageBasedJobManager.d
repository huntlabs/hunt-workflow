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

module flow.job.service.impl.asyncexecutor.message.AbstractMessageBasedJobManager;
import hunt.time.LocalDateTime;

import flow.common.cfg.TransactionContext;
import flow.common.cfg.TransactionListener;
import flow.common.cfg.TransactionState;
import flow.common.context.Context;
import flow.common.interceptor.CommandContext;
import flow.job.service.api.HistoryJob;
import flow.job.service.api.JobInfo;
import flow.job.service.JobServiceConfiguration;
import flow.job.service.impl.asyncexecutor.DefaultJobManager;
//import flow.job.service.impl.history.async.AsyncHistorySession;
import flow.job.service.impl.persistence.entity.HistoryJobEntity;
import flow.job.service.impl.persistence.entity.JobEntity;
import flow.job.service.impl.persistence.entity.JobInfoEntity;
import hunt.logging;
import hunt.Exceptions;
/**
 * Abstract class that contains the main logic to send information about an async history data job to a message queue.
 * Subclasses are responsible for implementing the actual sending logic.
 *
 * @author Joram Barrez
 */
abstract class AbstractMessageBasedJobManager : DefaultJobManager {


    this() {
        super(null);
    }

    this(JobServiceConfiguration jobServiceConfiguration) {
        super(jobServiceConfiguration);
    }

    override
    protected void triggerExecutorIfNeeded(final JobEntity jobEntity) {
        prepareAndSendMessage(jobEntity);
    }

    override
    protected void triggerAsyncHistoryExecutorIfNeeded(HistoryJobEntity jobEntity) {
        prepareAndSendMessage(jobEntity);
    }

    override
    public void unacquire(JobInfo job) {

        JobInfoEntity jobInfoEntity = cast(JobInfoEntity) job;
        if (jobInfoEntity !is null) {
            implementationMissing(false);
            // When unacquiring, we up the lock time again., so that it isn't cleared by the reset expired thread.
            //jobInfoEntity.setLockExpirationTime(new Date(jobServiceConfiguration.getClock().getCurrentTime().getTime()
            //        + jobServiceConfiguration.getAsyncExecutor().getAsyncJobLockTimeInMillis()));
        }

        prepareAndSendMessage(job);
    }

    override
    public void unacquireWithDecrementRetries(JobInfo job) {
        HistoryJobEntity historyJobEntity = cast(HistoryJobEntity) job;
        if (historyJobEntity !is null) {
            if (historyJobEntity.getRetries() > 0) {
                historyJobEntity.setRetries(historyJobEntity.getRetries() - 1);
                unacquire(historyJobEntity);
            } else {
                jobServiceConfiguration.getHistoryJobEntityManager().deleteNoCascade(historyJobEntity);
            }
        } else {
            unacquire(job);
        }
    }

    protected void prepareAndSendMessage( JobInfo job) {

        // If it's an async job, the transaction context is still active
        // If it's an async history job, the transaction context might be gone (due to the command context
        // already being closing), but the asyncHistorySession still has it stored.

        TransactionContext transactionContext = Context.getTransactionContext();
        if (transactionContext is null) {
            if ( cast(HistoryJobEntity)job !is null) {
                implementationMissing(false);
                //CommandContext commandContext = Context.getCommandContext();
                //AsyncHistorySession asyncHistorySession = commandContext.getSession(typeid(AsyncHistorySession));
                //transactionContext = asyncHistorySession.getTransactionContext();
            }
        }

        if (transactionContext !is null) {
            transactionContext.addTransactionListener(TransactionState.COMMITTED, new class TransactionListener {
                public void execute(CommandContext commandContext) {
                    sendMessage(job);
                }
            });

        } else {

          //  LOGGER.warn("Could not send message for job {}: no transaction context active nor is it a history job", job.getId());

        }

    }

    /**
     * Subclasses need to implement this method: it should contain the actual sending of the message
     * using the job data provided in the parameter.
     */
    protected abstract void sendMessage(JobInfo job);

}
