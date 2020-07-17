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

module flow.common.cfg.standalone.StandaloneMybatisTransactionContext;





import hunt.collection.ArrayList;
import hunt.collection.HashMap;
import hunt.collection.List;
import hunt.collection.Map;

import flow.common.cfg.TransactionContext;
import flow.common.cfg.TransactionListener;
import flow.common.cfg.TransactionPropagation;
import flow.common.cfg.TransactionState;
import flow.common.context.Context;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandConfig;
import flow.common.interceptor.CommandContext;
import flow.common.interceptor.CommandExecutor;
import hunt.logging;
import hunt.Exceptions;
import hunt.Object;
/**
 * @author Tom Baeyens
 * @author Joram Barrez
 */
class StandaloneMybatisTransactionContext : TransactionContext {

    protected CommandContext commandContext;
   // protected DbSqlSession dbSqlSession;
    protected Map!(TransactionState, List!TransactionListener) stateTransactionListeners;

    this(CommandContext commandContext) {
        this.commandContext = commandContext;
        //this.dbSqlSession = Context.getCommandContext().getSession(DbSqlSession.class);
    }

    public void addTransactionListener(TransactionState transactionState, TransactionListener transactionListener) {
        if (stateTransactionListeners is null) {
            stateTransactionListeners = new HashMap!(TransactionState, List!TransactionListener)();
        }
        List!TransactionListener transactionListeners = stateTransactionListeners.get(transactionState);
        if (transactionListeners is null) {
            transactionListeners = new ArrayList!TransactionListener();
            stateTransactionListeners.put(transactionState, transactionListeners);
        }
        transactionListeners.add(transactionListener);
    }

    public void commit() {

        logDebug("firing event committing...");
        fireTransactionEvent(TransactionState.COMMITTING, false);

        logDebug("committing the ibatis sql session...");
        //dbSqlSession.commit();
        implementationMissing(false);
        logDebug("firing event committed...");
        fireTransactionEvent(TransactionState.COMMITTED, true);

    }

    /**
     * Fires the event for the provided {@link TransactionState}.
     *
     * @param transactionState
     *            The {@link TransactionState} for which the listeners will be called.
     * @param executeInNewContext
     *            If true, the listeners will be called in a new command context. This is needed for example when firing the {@link TransactionState#COMMITTED} event: the transaction is already
     *            committed and executing logic in the same context could lead to strange behaviour (for example doing a {@link SqlSession#update(string)} would actually roll back the update (as the
     *            MyBatis context is already committed and the internal flags have not been correctly set).
     */
    protected void fireTransactionEvent(TransactionState transactionState, bool executeInNewContext) {
        if (stateTransactionListeners is null) {
            return;
        }
        List!TransactionListener transactionListeners = stateTransactionListeners.get(transactionState);
        if (transactionListeners is null) {
            return;
        }

        if (executeInNewContext) {
            CommandExecutor commandExecutor = Context.getCommandContext().getCurrentEngineConfiguration().getCommandExecutor();
            CommandConfig commandConfig = new CommandConfig(false, TransactionPropagation.REQUIRES_NEW);
            commandExecutor.execute(commandConfig, new class Command!Void {
                public Void execute(CommandContext commandContext) {
                    executeTransactionListeners(transactionListeners, commandContext);
                    return null;
                }
            });
        } else {
            executeTransactionListeners(transactionListeners, commandContext);
        }

    }

    protected void executeTransactionListeners(List!TransactionListener transactionListeners, CommandContext commandContext) {
        foreach (TransactionListener transactionListener ; transactionListeners) {
            transactionListener.execute(commandContext);
        }
    }

    public void rollback() {
        try {
            try {
              logDebug("firing event rolling back...");
                fireTransactionEvent(TransactionState.ROLLINGBACK, false);

            } catch (Throwable exception) {
                logInfo("Exception during transaction: {}");
                commandContext.exception(exception);
            } finally {
                logDebug("rolling back ibatis sql session...");
                implementationMissing(false);
                //dbSqlSession.rollback();
            }

        } catch (Throwable exception) {
          logInfo("Exception during transaction: {}");
            commandContext.exception(exception);

        } finally {
          logDebug("firing event rolled back...");
            fireTransactionEvent(TransactionState.ROLLED_BACK, true);
        }
    }
}
