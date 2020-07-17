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

module flow.common.interceptor.CommandContextInterceptor;





import hunt.collection.HashMap;
import hunt.collection.Map;

import flow.common.AbstractEngineConfiguration;
import flow.common.context.Context;
import flow.common.interceptor.AbstractCommandInterceptor;
import flow.common.interceptor.CommandContextFactory;
import flow.common.AbstractEngineConfiguration;
import flow.common.AbstractServiceConfiguration;
import flow.common.interceptor.CommandConfig;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
//import org.slf4j.Logger;
//import org.slf4j.LoggerFactory;
import hunt.logging;
/**
 * @author Tom Baeyens
 * @author Joram Barrez
 */
class CommandContextInterceptor : AbstractCommandInterceptor {

    protected CommandContextFactory commandContextFactory;
    protected string currentEngineConfigurationKey;
    protected Map!(string, AbstractEngineConfiguration) engineConfigurations ;//= new HashMap<>();
    protected Map!(string, AbstractServiceConfiguration) serviceConfigurations;// = new HashMap<>();

    this() {
        engineConfigurations = new HashMap!(string, AbstractEngineConfiguration);
        serviceConfigurations = new HashMap!(string, AbstractServiceConfiguration);
    }

    this(CommandContextFactory commandContextFactory) {
        this.commandContextFactory = commandContextFactory;
        engineConfigurations = new HashMap!(string, AbstractEngineConfiguration);
        serviceConfigurations = new HashMap!(string, AbstractServiceConfiguration);
    }

    public Object execute(CommandConfig config, CommandAbstract command) {
        CommandContext commandContext = Context.getCommandContext();

        bool contextReused = false;
        AbstractEngineConfiguration previousEngineConfiguration = null;

        // We need to check the exception, because the transaction can be in a
        // rollback state, and some other command is being fired to compensate (eg. decrementing job retries)
        if (!config.isContextReusePossible() || commandContext is null || commandContext.getException() !is null) {
            commandContext = commandContextFactory.createCommandContext(command);
            commandContext.setEngineConfigurations(engineConfigurations);

        } else {
            logInfo("Valid context found. Reusing it for the current command '{}'");
            contextReused = true;
            commandContext.setReused(true);
            previousEngineConfiguration = commandContext.getCurrentEngineConfiguration();
        }

        try {
            commandContext.setCurrentEngineConfiguration(engineConfigurations.get(currentEngineConfigurationKey));
            // Push on stack
            logInfo("Push on stack ..... %s" , typeid(commandContext.getCommand).toString);
            //CommandContext copy = commandContext;
            Context.setCommandContext(commandContext);

            return next.execute(config, command);

        } catch (Exception e) {

            commandContext.exception(e);

        } finally {
            try {
                if (!contextReused) {
                    commandContext.close();
                }

            } finally {

                // Pop from stack
                Context.removeCommandContext();
                //commandContext.setCurrentEngineConfiguration(previousEngineConfiguration);
            }
        }

        // Rethrow exception if needed
        if (contextReused && commandContext.getException() !is null) {

            // If it's reused, we need to throw the exception again so it propagates upwards,
            // but the exception needs to be reset again or the parent call can incorrectly be marked
            // as having an exception (the nested call can be try-catched for example)
            Throwable exception = commandContext.getException();
            commandContext.resetException();

            // Wrapping it to avoid having 'throws throwable' in all method signatures
            //if (exception instanceof FlowableException) {
            //    throw (FlowableException) exception;
            //} else {
            //    throw new FlowableException("Exception during command execution", exception);
            //}
        }

        return null;
    }

    public CommandContextFactory getCommandContextFactory() {
        return commandContextFactory;
    }

    public void setCommandContextFactory(CommandContextFactory commandContextFactory) {
        this.commandContextFactory = commandContextFactory;
    }

    public string getCurrentEngineConfigurationKey() {
        return currentEngineConfigurationKey;
    }

    public void setCurrentEngineConfigurationKey(string currentEngineConfigurationKey) {
        this.currentEngineConfigurationKey = currentEngineConfigurationKey;
    }

    public Map!(string, AbstractEngineConfiguration) getEngineConfigurations() {
        return engineConfigurations;
    }

    public void setEngineConfigurations(Map!(string, AbstractEngineConfiguration) engineConfigurations) {
        this.engineConfigurations = engineConfigurations;
    }

    public Map!(string, AbstractServiceConfiguration) getServiceConfigurations() {
        return serviceConfigurations;
    }

    public void setServiceConfigurations(Map!(string, AbstractServiceConfiguration) serviceConfigurations) {
        this.serviceConfigurations = serviceConfigurations;
    }

}
