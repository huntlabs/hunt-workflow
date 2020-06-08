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


import flow.common.cmd.CustomSqlExecution;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.engine.impl.util.CommandContextUtil;

/**
 * @author jbarrez
 */
class ExecuteCustomSqlCmd!(Mapper, ResultType) implements Command!ResultType {

    protected Class!Mapper mapperClass;
    protected CustomSqlExecution!(Mapper, ResultType) customSqlExecution;

    public ExecuteCustomSqlCmd(Class!Mapper mapperClass, CustomSqlExecution!(Mapper, ResultType) customSqlExecution) {
        this.mapperClass = mapperClass;
        this.customSqlExecution = customSqlExecution;
    }

    override
    public ResultType execute(CommandContext commandContext) {
        Mapper mapper = CommandContextUtil.getDbSqlSession(commandContext).getSqlSession().getMapper(mapperClass);
        return customSqlExecution.execute(mapper);
    }

}
