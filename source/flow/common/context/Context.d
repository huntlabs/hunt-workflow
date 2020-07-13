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

module flow.common.context.Context;





import hunt.collection.List;
import hunt.collection.ArrayList;
import flow.common.cfg.TransactionContext;
import flow.common.interceptor.CommandContext;
import flow.common.transaction.TransactionContextHolder;
/**
 * @author Tom Baeyens
 * @author Daniel Meyer
 * @author Joram Barrez
 */
class Context {

    //protected static ThreadLocal<Stack<CommandContext>> commandContextThreadLocal = new ThreadLocal<>();
     static List!CommandContext commandContextThreadLocal;
    this()
      {
          //commandContextThreadLocal = new ArrayList!CommandContext;
      }
    public static CommandContext getCommandContext() {
       // Stack<CommandContext> stack = getStack(commandContextThreadLocal);
        if (commandContextThreadLocal is null )
        {
          commandContextThreadLocal = new ArrayList!CommandContext;
        }
        if (commandContextThreadLocal.isEmpty()) {
            return null;
        }
        return  commandContextThreadLocal.get(commandContextThreadLocal.size()-1);
        //return stack.peek();
    }

    public static void setCommandContext(CommandContext commandContext) {
        if (commandContextThreadLocal is null )
        {
          commandContextThreadLocal = new ArrayList!CommandContext;
        }
        commandContextThreadLocal.add(commandContext);
    }

    public static void removeCommandContext() {
        if (commandContextThreadLocal is null )
        {
          commandContextThreadLocal = new ArrayList!CommandContext;
        }
        int s = commandContextThreadLocal.size();
        if (s != 0)
        {
            commandContextThreadLocal.removeAt(s-1);
        }
    }

    public static TransactionContext getTransactionContext() {
        return TransactionContextHolder.getTransactionContext();
    }

    public static void setTransactionContext(TransactionContext transactionContext) {
        TransactionContextHolder.setTransactionContext(transactionContext);
    }

    public static void removeTransactionContext() {
        TransactionContextHolder.removeTransactionContext();
    }

    //protected static <T> Stack<T> getStack(ThreadLocal<Stack<T>> threadLocal) {
    //    Stack<T> stack = threadLocal.get();
    //    if (stack is null) {
    //        stack = new Stack<>();
    //        threadLocal.set(stack);
    //    }
    //    return stack;
    //}

}
