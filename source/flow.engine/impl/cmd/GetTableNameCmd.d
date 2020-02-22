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

import flow.common.api.FlowableIllegalArgumentException;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.engine.impl.util.CommandContextUtil;

class GetTableNameCmd implements Command<string>, Serializable {

    private static final long serialVersionUID = 1L;

    protected Class<?> entityClass;
    protected bool withPrefix = true;

    public GetTableNameCmd(Class<?> entityClass) {
        this.entityClass = entityClass;
    }

    public GetTableNameCmd(Class<?> entityClass, bool withPrefix) {
        this.entityClass = entityClass;
        this.withPrefix = withPrefix;
    }

    @Override
    public string execute(CommandContext commandContext) {
        if (entityClass is null) {
            throw new FlowableIllegalArgumentException("entityClass is null");
        }
        return CommandContextUtil.getTableDataManager(commandContext).getTableName(entityClass, withPrefix);
    }

}