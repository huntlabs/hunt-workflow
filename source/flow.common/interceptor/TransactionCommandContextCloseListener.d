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
 
module flow.common.interceptor.TransactionCommandContextCloseListener; 
 
 
 import flow.common.interceptor.CommandContextCloseListener;

import flow.common.interceptor.CommandContext;
import flow.common.cfg.TransactionContext;

/**
 * @author Joram Barrez
 */
class TransactionCommandContextCloseListener : CommandContextCloseListener {

    protected TransactionContext transactionContext;

    this(TransactionContext transactionContext) {
        this.transactionContext = transactionContext;
    }

    public void closing(CommandContext commandContext) {

    }

    public void afterSessionsFlush(CommandContext commandContext) {
        transactionContext.commit();
    }

    public void closed(CommandContext commandContext) {

    }

    public void closeFailure(CommandContext commandContext) {
        transactionContext.rollback();
    }

}
