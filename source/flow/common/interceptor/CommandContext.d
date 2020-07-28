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

module flow.common.interceptor.CommandContext;


//import hunt.collection.ArrayList;
//import hunt.collection.HashMap;
//import hunt.collection.LinkedList;
//import hunt.collection.List;
//import hunt.collection.Map;
import flow.common.api.DataManger;
import flow.common.AbstractEngineConfiguration;
import flow.common.interceptor.Command;
import hunt.collection.Map;
import hunt.collection.List;
import hunt.collection.LinkedList;
import hunt.collection.ArrayList;
import hunt.collection.HashMap;
import hunt.logging;
import flow.common.interceptor.SessionFactory;
import flow.common.interceptor.Session;
import flow.common.interceptor.CommandContextCloseListener;
import hunt.Exceptions;
import flow.common.persistence.entity.Entity;
import flow.engine.impl.bpmn.parser.factory.DefaultListenerFactory;
import flow.common.persistence.cache.EntityCache;
import flow.common.persistence.cache.EntityCacheImpl;
/**
 * @author Tom Baeyens
 * @author Agim Emruli
 * @author Joram Barrez
 */

class CommandContext {

    protected Map!(string, AbstractEngineConfiguration) engineConfigurations;
    protected AbstractEngineConfiguration currentEngineConfiguration;
    protected CommandAbstract command;
    protected Map!(TypeInfo, SessionFactory) sessionFactories;
    protected Map!(TypeInfo, Session) sessions ;// = new HashMap<>();
    protected Throwable _exception;
    protected List!CommandContextCloseListener closeListeners;
    protected Map!(string, Object) attributes; // General-purpose storing of anything during the lifetime of a command context
    protected bool reused;
    protected LinkedList!Object resultStack ;//= new LinkedList<>(); // needs to be a stack, as JavaDelegates can do api calls again
    protected EntityCache entityCache;



    static DataManger[Entity] insertJob;


    this(CommandAbstract command) {
        this.command = command;
        sessions =  new HashMap!(TypeInfo, Session);
        resultStack = new LinkedList!Object;
        entityCache = new EntityCacheImpl();
    }

    public EntityCache getSession()
    {
        return entityCache;
    }

    public void close() {

        // The intention of this method is that all resources are closed properly, even if exceptions occur
        // in close or flush methods of the sessions or the transaction context.
        try {
            try {
                try {
                    executeCloseListenersClosing();
                    if (_exception is null) {
                        flushSessions();
                    }
                } catch (Throwable exception) {
                   // _exception(exception);

                } finally {

                    //try {
                        if (_exception is null) {
                            executeCloseListenersAfterSessionFlushed();
                        }
                    //} catch (Throwable exception) {
                    //  //  exception(exception);
                    //}

                    if (_exception !is null) {
                        logException();
                        executeCloseListenersCloseFailure();
                    } else {
                        executeCloseListenersClosed();
                    }

                }
            } catch (Throwable exception) {
                // Catch exceptions during rollback
                //exception(exception);
            } finally {
                // Sessions need to be closed, regardless of exceptions/commit/rollback
                closeSessions();
            }

        } catch (Throwable exception) {
            // Catch exceptions during session closing
           // exception(exception);
        }

        if (_exception !is null) {
           // rethrowExceptionIfNeeded();
        }
    }

    protected void logException() {
        implementationMissing(false);
        //if (exception instanceof FlowableException && !((FlowableException) exception).isLogged()) {
        //    return;
        //}
        //
        //if (exception instanceof FlowableOptimisticLockingException) {
        //    // reduce log level, as normally we're not interested in logging this exception
        //    LOGGER.debug("Optimistic locking exception : {}", exception.getMessage(), exception);
        //
        //} else if (exception instanceof FlowableException && ((FlowableException) exception).isReduceLogLevel()) {
        //    // reduce log level, because this may have been caused because of job deletion due to cancelActiviti="true"
        //    LOGGER.info("Error while closing command context", exception);
        //
        //} else {
        //    LOGGER.error("Error while closing command context", exception);
        //
        //}
    }

    //protected void rethrowExceptionIfNeeded() throws Error {
    //    if (exception instanceof Error) {
    //        throw (Error) exception;
    //    } else if (exception instanceof RuntimeException) {
    //        throw (RuntimeException) exception;
    //    } else {
    //        throw new FlowableException("exception while executing command " + command, exception);
    //    }
    //}

    public void addCloseListener(CommandContextCloseListener commandContextCloseListener) {
        if (closeListeners is null) {
            closeListeners = new ArrayList!CommandContextCloseListener();
        }
        closeListeners.add(commandContextCloseListener);
    }

    public List!CommandContextCloseListener getCloseListeners() {
        return closeListeners;
    }

    protected void executeCloseListenersClosing() {
        if (closeListeners !is null) {
            try {
                foreach (CommandContextCloseListener listener ; closeListeners) {
                    listener.closing(this);
                }
            } catch (Throwable exception) {
                //exception(exception);
            }
        }
    }

    protected void executeCloseListenersAfterSessionFlushed() {
        if (closeListeners !is null) {
            try {
                foreach (CommandContextCloseListener listener ; closeListeners) {
                    listener.afterSessionsFlush(this);
                }
            } catch (Throwable exception) {
               // exception(exception);
            }
        }
    }

    protected void executeCloseListenersClosed() {
        if (closeListeners !is null) {
            try {
                foreach (CommandContextCloseListener listener ; closeListeners) {
                    listener.closed(this);
                }
            } catch (Throwable exception) {
                //exception(exception);
            }
        }
    }

    protected void executeCloseListenersCloseFailure() {
        if (closeListeners !is null) {
            try {
                foreach (CommandContextCloseListener listener ; closeListeners) {
                    listener.closeFailure(this);
                }
            } catch (Throwable exception) {
                //exception(exception);
            }
        }
    }

    protected void flushSessions() {
         if(insertJob.length == 0)
            return;
         auto em = entityManagerFactory.currentEntityManager();
         logInfof("size!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! %d",insertJob.length);
         em.getTransaction().begin();

         foreach (TypeInfo type ; insertOrder)
         {
             foreach (k ,v ; insertJob)
             {
               logInfof("type!!!!!!!!!!!!!  %s  ---  %s", typeid(v).toString , type.toString );
               if (v.getTypeInfo() == type)
               {
                 v.insertTrans(k,em);
               }
             }
         }

         em.getTransaction().commit();
         insertJob.clear;
        //foreach (Session session ; sessions.values()) {
        //    session.flush();
        //}
    }

    protected void closeSessions() {
        foreach (Session session ; sessions.values()) {
            try {
                session.close();
            } catch (Throwable exception) {
                //exception(exception);
            }
        }
    }

    /**
     * Stores the provided exception on this {@link CommandContext} instance. That exception will be rethrown at the end of closing the {@link CommandContext} instance.
     *
     * If there is already an exception being stored, a 'masked exception' message will be logged.
     */
    public void exception(Throwable exception) {
        if (this._exception is null) {
            this._exception = exception;

        } else {
            logError("masked exception in command context. for root cause, see below as it will be rethrown later.");
        }
    }

    public void resetException() {
        this._exception = null;
    }

    public void addAttribute(string key, Object value) {
        if (attributes is null) {
            attributes = new HashMap!(string, Object);
        }
        attributes.put(key, value);
    }

    public Object getAttribute(string key) {
        if (attributes !is null) {
            return attributes.get(key);
        }
        return null;
    }

    public Session getSession(TypeInfo sessionClass) {
        Session session = sessions.get(sessionClass);
        if (session is null) {
            SessionFactory sessionFactory = sessionFactories.get(sessionClass);
            if (sessionFactory is null) {
                //throw new FlowableException("no session factory configured for " + sessionClass.getName());
                logError("no session factory configured for %s",sessionClass);
            }
            session = sessionFactory.openSession(this);
            sessions.put(sessionClass, session);
        }

        return session;
    }

    public Map!(TypeInfo, SessionFactory) getSessionFactories() {
        return sessionFactories;
    }

    public void setSessionFactories(Map!(TypeInfo, SessionFactory) sessionFactories) {
        this.sessionFactories = sessionFactories;
    }

    public AbstractEngineConfiguration getCurrentEngineConfiguration() {
        return currentEngineConfiguration;
    }

    public void setCurrentEngineConfiguration(AbstractEngineConfiguration currentEngineConfiguration) {
        this.currentEngineConfiguration = currentEngineConfiguration;
    }

    public Map!(string, AbstractEngineConfiguration) getEngineConfigurations() {
        return engineConfigurations;
    }

    public void setEngineConfigurations(Map!(string, AbstractEngineConfiguration) engineConfigurations) {
        this.engineConfigurations = engineConfigurations;
    }

    public void addEngineConfiguration(string engineKey, AbstractEngineConfiguration engineConfiguration) {
        if (engineConfigurations is null) {
            engineConfigurations = new HashMap!(string,AbstractEngineConfiguration);
        }
        engineConfigurations.put(engineKey, engineConfiguration);
    }

    // getters and setters
    // //////////////////////////////////////////////////////

    public CommandAbstract getCommand() {
        return command;
    }

    public Map!(TypeInfo, Session)getSessions() {
        return sessions;
    }

    public Throwable getException() {
        return _exception;
    }

    public bool isReused() {
        return reused;
    }

    public void setReused(bool reused) {
        this.reused = reused;
    }

    public Object getResult() {
        return resultStack.pollLast();
    }

    public void setResult(Object result) {
        resultStack.add(result);
    }

}
