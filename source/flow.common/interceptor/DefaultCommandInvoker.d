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

module flow.common.interceptor.DefaultCommandInvoker;


import flow.event.registry.ChannelDefinitionQueryImpl;
import flow.event.registry.cmd.SchemaOperationsEventRegistryEngineBuild;
import flow.common.interceptor.AbstractCommandInterceptor;
import flow.common.context.Context;
import flow.common.interceptor.CommandConfig;
import flow.common.interceptor.CommandContext;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandInterceptor;

class DefaultCommandInvoker : AbstractCommandInterceptor {

  //  Object execute(CommandConfig config, CommandAbstract command);
   // @Override
    public Object execute(CommandConfig config,  CommandAbstract command) {
        CommandContext commandContext = Context.getCommandContext();
        //SchemaOperationsIdmEngineBuild

        if (cast(SchemaOperationsEventRegistryEngineBuild)command !is null)
        {
          Object result = (cast(SchemaOperationsEventRegistryEngineBuild)command).execute(commandContext);
          return result;
        }else if(cast(ChannelDefinitionQueryImpl)command !is null)
        {
          Object result = (cast(ChannelDefinitionQueryImpl)command).execute(commandContext);
          return result;
        }else
        {
          return null;
        }


    }

    override
    public CommandInterceptor getNext() {
        return null;
    }

    override
    public void setNext(CommandInterceptor next) {
       // throw new UnsupportedOperationException("CommandInvoker must be the last interceptor in the chain");
    }

}
