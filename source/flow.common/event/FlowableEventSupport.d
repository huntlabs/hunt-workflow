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

module flow.common.event.FlowableEventSupport;





import hunt.collection.HashMap;
import  hunt.collection.List;
import  hunt.collection.Map;
import hunt.collection.ArrayList;
import hunt.logging;
import flow.common.api.FlowableIllegalArgumentException;
import flow.common.api.deleg.event.FlowableEvent;
import flow.common.api.deleg.event.FlowableEventListener;
import flow.common.api.deleg.event.FlowableEventType;
import flow.common.cfg.TransactionContext;
import flow.common.cfg.TransactionState;
//import flow.common.context.Context;
import hunt.Exceptions;
/**
 * Class that allows adding and removing event listeners and dispatching events to the appropriate listeners.
 *
 * @author Frederik Heremans
 */
class FlowableEventSupport {

    protected List!FlowableEventListener eventListeners;
    protected Map!(FlowableEventType, List!FlowableEventListener) typedListeners;

    this() {
        eventListeners = new ArrayList!FlowableEventListener;
        typedListeners = new HashMap!(FlowableEventType, List!FlowableEventListener);
    }

    public void addEventListener(FlowableEventListener listenerToAdd) {
        if (listenerToAdd is null) {
            throw new FlowableIllegalArgumentException("Listener cannot be null.");
        }
        if (!eventListeners.contains(listenerToAdd)) {
            eventListeners.add(listenerToAdd);
        }
    }

    //public synchronized void addEventListener(FlowableEventListener listenerToAdd, FlowableEventType... types) {
    //    if (listenerToAdd is null) {
    //        throw new FlowableIllegalArgumentException("Listener cannot be null.");
    //    }
    //
    //    if (types is null || types.length == 0) {
    //        addEventListener(listenerToAdd);
    //
    //    } else {
    //        for (FlowableEventType type : types) {
    //            addTypedEventListener(listenerToAdd, type);
    //        }
    //    }
    //}

    public void removeEventListener(FlowableEventListener listenerToRemove) {
        eventListeners.remove(listenerToRemove);

        foreach (List!FlowableEventListener listeners ; typedListeners.values()) {
            listeners.remove(listenerToRemove);
        }
    }

    public void dispatchEvent(FlowableEvent event) {
        if (event is null) {
            throw new FlowableIllegalArgumentException("Event cannot be null.");
        }

        if (event.getType() is null) {
            throw new FlowableIllegalArgumentException("Event type cannot be null.");
        }

        // Call global listeners
        if (!eventListeners.isEmpty()) {
            foreach (FlowableEventListener listener ; eventListeners) {
                dispatchEvent(event, listener);
            }
        }

        // Call typed listeners, if any
        List!FlowableEventListener typed = typedListeners.get(event.getType());
        if (typed !is null && !typed.isEmpty()) {
            foreach (FlowableEventListener listener ; typed) {
                dispatchEvent(event, listener);
            }
        }
    }

    protected void dispatchEvent(FlowableEvent event, FlowableEventListener listener) {
        if (listener.isFireOnTransactionLifecycleEvent()) {
            dispatchTransactionEventListener(event, listener);
        } else {
            dispatchNormalEventListener(event, listener);
        }
    }

    protected void dispatchNormalEventListener(FlowableEvent event, FlowableEventListener listener) {
        try {
            listener.onEvent(event);
        } catch (Throwable t) {
            if (listener.isFailOnException()) {
                throw t;
            } else {
                // Ignore the exception and continue notifying remaining listeners. The listener
                // explicitly states that the exception should not bubble up
                //LOGGER.warn("Exception while executing event-listener, which was ignored", t);
                logWarning("Exception while executing event-listener, which was ignored %s",t.msg);
            }
        }
    }

    protected void dispatchTransactionEventListener(FlowableEvent event, FlowableEventListener listener) {
        implementationMissing(false);
        //TransactionContext transactionContext = Context.getTransactionContext();
        //if (transactionContext is null) {
        //    return;
        //}
        //
        //ExecuteEventListenerTransactionListener transactionListener = new ExecuteEventListenerTransactionListener(listener, event);
        //if (listener.getOnTransaction().equalsIgnoreCase(TransactionState.COMMITTING.name())) {
        //    transactionContext.addTransactionListener(TransactionState.COMMITTING, transactionListener);
        //
        //} else if (listener.getOnTransaction().equalsIgnoreCase(TransactionState.COMMITTED.name())) {
        //    transactionContext.addTransactionListener(TransactionState.COMMITTED, transactionListener);
        //
        //} else if (listener.getOnTransaction().equalsIgnoreCase(TransactionState.ROLLINGBACK.name())) {
        //    transactionContext.addTransactionListener(TransactionState.ROLLINGBACK, transactionListener);
        //
        //} else if (listener.getOnTransaction().equalsIgnoreCase(TransactionState.ROLLED_BACK.name())) {
        //    transactionContext.addTransactionListener(TransactionState.ROLLED_BACK, transactionListener);
        //
        //} else {
        //    LOGGER.warn("Unrecognised TransactionState {}", listener.getOnTransaction());
        //}
    }

    protected  void addTypedEventListener(FlowableEventListener listener, FlowableEventType type) {
        List!FlowableEventListener listeners = typedListeners.get(type);
        if (listeners is null) {
            // Add an empty list of listeners for this type
            listeners = new ArrayList!FlowableEventListener;
            typedListeners.put(type, listeners);
        }

        if (!listeners.contains(listener)) {
            listeners.add(listener);
        }
    }
}
