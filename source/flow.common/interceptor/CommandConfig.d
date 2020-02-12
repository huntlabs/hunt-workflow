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
 
module flow.common.interceptor.CommandConfig;
 


import flow.common.cfg.TransactionPropagation;

/**
 * Configuration settings for the command interceptor chain.
 * 
 * Instances of this class are immutable, and thus thread- and share-safe.
 * 
 * @author Marcus Klimstra (CGI)
 */
class CommandConfig {

    private bool contextReusePossible;
    private TransactionPropagation propagation;

    this() {
        this.contextReusePossible = true;
        this.propagation = TransactionPropagation.REQUIRED;
    }

    this(bool contextReusePossible) {
        this.contextReusePossible = contextReusePossible;
        this.propagation = TransactionPropagation.REQUIRED;
    }

    this(bool contextReusePossible, TransactionPropagation transactionPropagation) {
        this.contextReusePossible = contextReusePossible;
        this.propagation = transactionPropagation;
    }

    this(CommandConfig commandConfig) {
        this.contextReusePossible = commandConfig.contextReusePossible;
        this.propagation = commandConfig.propagation;
    }

    public bool isContextReusePossible() {
        return contextReusePossible;
    }

    public TransactionPropagation getTransactionPropagation() {
        return propagation;
    }

    public CommandConfig setContextReusePossible(bool contextReusePossible) {
        CommandConfig config = new CommandConfig(this);
        config.contextReusePossible = contextReusePossible;
        return config;
    }

    public CommandConfig transactionRequired() {
        CommandConfig config = new CommandConfig(this);
        config.propagation = TransactionPropagation.REQUIRED;
        return config;
    }

    public CommandConfig transactionRequiresNew() {
        CommandConfig config = new CommandConfig();
        config.contextReusePossible = false;
        config.propagation = TransactionPropagation.REQUIRES_NEW;
        return config;
    }

    public CommandConfig transactionNotSupported() {
        CommandConfig config = new CommandConfig();
        config.contextReusePossible = false;
        config.propagation = TransactionPropagation.NOT_SUPPORTED;
        return config;
    }
}
