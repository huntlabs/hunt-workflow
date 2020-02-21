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
 
module flow.common.interceptor.TransactionContextInterceptor;
 
 
 


import flow.common.cfg.TransactionContext;
import flow.common.cfg.TransactionContextFactory;
import flow.common.cfg.TransactionPropagation;
import flow.common.context.Context;
import flow.common.interceptor.AbstractCommandInterceptor;
import flow.common.interceptor.CommandConfig;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.common.interceptor.TransactionCommandContextCloseListener;
//import org.slf4j.Logger;
//import org.slf4j.LoggerFactory;
import hunt.logging;
/**
 * @author Joram Barrez
 */
class TransactionContextInterceptor : AbstractCommandInterceptor {

    protected TransactionContextFactory transactionContextFactory;

    this() {
    }

    this(TransactionContextFactory transactionContextFactory) {
        this.transactionContextFactory = transactionContextFactory;
    }

    public Object execute(CommandConfig config, CommandAbstract command) {

        CommandContext commandContext = Context.getCommandContext();
        // Storing it in a variable, to reference later (it can change during command execution)
        bool openTransaction = !config.getTransactionPropagation().equals(TransactionPropagation.NOT_SUPPORTED)
                && transactionContextFactory !is null && !commandContext.isReused();
        bool isContextSet = false;

        try {

            if (openTransaction) {
                TransactionContext transactionContext = cast(TransactionContext) transactionContextFactory.openTransactionContext(commandContext);
                Context.setTransactionContext(transactionContext);
                isContextSet = true;
                commandContext.addCloseListener(new TransactionCommandContextCloseListener(transactionContext));
            }

            return next.execute(config, command);

        } finally {
            if (openTransaction && isContextSet) {
                Context.removeTransactionContext();
            }
        }

    }

    public TransactionContextFactory getTransactionContextFactory() {
        return transactionContextFactory;
    }

    public void setTransactionContextFactory(TransactionContextFactory transactionContextFactory) {
        this.transactionContextFactory = transactionContextFactory;
    }

}
