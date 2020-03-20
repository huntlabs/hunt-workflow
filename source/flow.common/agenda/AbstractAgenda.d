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
module flow.common.agenda.AbstractAgenda;

import hunt.collection.LinkedList;

import flow.common.api.FlowableException;
import flow.common.interceptor.CommandContext;
import flow.common.agenda.Agenda;
import hunt.util.Common;
/**
 * @author Joram Barrez
 */
abstract class AbstractAgenda : Agenda {


    protected CommandContext commandContext;
    protected LinkedList!Runnable operations  ;//= new LinkedList<>();

    this(CommandContext commandContext) {
        this.commandContext = commandContext;
        operations = new  LinkedList!Runnable;
    }


    public bool isEmpty() {
        return operations.isEmpty();
    }


    public Runnable getNextOperation() {
        assertOperationsNotEmpty();
        return operations.poll();
    }


    public Runnable peekOperation() {
        assertOperationsNotEmpty();
        return operations.peek();
    }

    protected void assertOperationsNotEmpty() {
        if (operations.isEmpty()) {
            throw new FlowableException("Unable to peek empty agenda.");
        }
    }

    /**
     * Generic method to plan a {@link Runnable}.
     */

    public void planOperation(Runnable operation) {
        operations.add(operation);
        //if (LOGGER.isDebugEnabled()) {
        //    LOGGER.debug("Operation {} added to agenda", operation.getClass());
        //}
    }

    public LinkedList!Runnable getOperations() {
        return operations;
    }

    public CommandContext getCommandContext() {
        return commandContext;
    }

    public void setCommandContext(CommandContext commandContext) {
        this.commandContext = commandContext;
    }


    public void flush() {

    }


    public void close() {

    }

}
