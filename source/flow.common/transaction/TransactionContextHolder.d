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

module flow.common.transaction.TransactionContextHolder;





import hunt.collection.List;
import hunt.collection.ArrayList;
import flow.common.cfg.TransactionContext;

/**
 * Holder for a threadlocal stack of {@link BaseTransactionContext} objects. Different engines (process/idm/dmn/form/...) use this 'shared' object to see if another engine has already started a
 * transaction or not.
 *
 * @author Joram Barrez
 */
class TransactionContextHolder {

    //protected static ThreadLocal<Stack<TransactionContext>> transactionContextThreadLocal = new ThreadLocal<>();
    List!TransactionContext transactionContextThreadLocal;
  shared static  this()
    {
        transactionContextThreadLocal = new ArrayList!TransactionContext;
    }
    public static TransactionContext getTransactionContext() {
        //Stack<TransactionContext> stack = getStack(transactionContextThreadLocal);
        if (transactionContextThreadLocal.isEmpty()) {
            return null;
        }
        return  transactionContextThreadLocal.get(transactionContextThreadLocal.size()-1);
    }

    public static void setTransactionContext(TransactionContext transactionContext) {
        transactionContextThreadLocal.add(transactionContext);
    }

    public static void removeTransactionContext() {
        int s = transactionContextThreadLocal.size();
        if (s != 0)
        {
            transactionContextThreadLocal.removeAt(s-1);
        }
    }

    public static bool isTransactionContextActive() {
        return !transactionContextThreadLocal.isEmpty();
    }
    //
    //protected static <T> Stack<T> getStack(ThreadLocal<Stack<T>> threadLocal) {
    //    Stack<T> stack = threadLocal.get();
    //    if (stack is null) {
    //        stack = new Stack<>();
    //        threadLocal.set(stack);
    //    }
    //    return stack;
    //}

}
