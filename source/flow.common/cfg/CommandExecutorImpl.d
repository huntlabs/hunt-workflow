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
 
module flow.common.cfg.CommandExecutorImpl;
 
 
 

import flow.common.interceptor.Command;
import flow.common.interceptor.CommandConfig;
import flow.common.interceptor.CommandExecutor;
import flow.common.interceptor.CommandInterceptor;

/**
 * Command executor that passes commands to the first interceptor in the chain. If no {@link CommandConfig} is passed, the default configuration will be used.
 * 
 * @author Marcus Klimstra (CGI)
 * @author Joram Barrez
 */
class CommandExecutorImpl : CommandExecutor {

    protected CommandConfig defaultConfig;
    protected CommandInterceptor first;

    this(CommandConfig defaultConfig, CommandInterceptor first) {
        this.defaultConfig = defaultConfig;
        this.first = first;
    }

    public CommandInterceptor getFirst() {
        return first;
    }

    public void setFirst(CommandInterceptor commandInterceptor) {
        this.first = commandInterceptor;
    }

    public CommandConfig getDefaultConfig() {
        return defaultConfig;
    }

    public Object execute(CommandAbstract command) {
        return execute(defaultConfig, command);
    }

    public Object execute(CommandConfig config, CommandAbstract command) {
        return first.execute(config, command);
    }

}
