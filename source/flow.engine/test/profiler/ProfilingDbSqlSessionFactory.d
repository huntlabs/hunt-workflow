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


import flow.common.db.DbSqlSessionFactory;
import flow.common.interceptor.CommandContext;
import flow.common.interceptor.Session;
import flow.engine.impl.util.CommandContextUtil;

/**
 * @author Joram Barrez
 */
class ProfilingDbSqlSessionFactory extends DbSqlSessionFactory {
    
    public ProfilingDbSqlSessionFactory(bool usePrefixId) {
        super(usePrefixId);
    }

    @Override
    public Session openSession(CommandContext commandContext) {
        return new ProfilingDbSqlSession(this, CommandContextUtil.getEntityCache(commandContext));
    }
}
