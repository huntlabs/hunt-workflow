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


import java.io.Serializable;
import java.util.Map;

import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.engine.impl.util.CommandContextUtil;

/**
 * @author Tom Baeyens
 */
class GetTableCountCmd implements Command<Map<string, Long>>, Serializable {

    private static final long serialVersionUID = 1L;

    @Override
    public Map<string, Long> execute(CommandContext commandContext) {
        return CommandContextUtil.getTableDataManager(commandContext).getTableCount();
    }
}
