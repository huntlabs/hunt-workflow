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

module flow.idm.engine.impl.cmd.GetPropertiesCmd;

import hunt.collection.HashMap;
import hunt.collection.List;
import hunt.collection.Map;

import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.idm.engine.impl.persistence.entity.IdmPropertyEntity;
import flow.idm.engine.impl.util.CommandContextUtil;
import hunt.Exceptions;
/**
 * @author Tom Baeyens
 */
class GetPropertiesCmd : Command!(Map!(string, string)) {


    public Map!(string, string) execute(CommandContext commandContext) {
        implementationMissing(false);
        return null;
        //List<IdmPropertyEntity> propertyEntities = CommandContextUtil.getPropertyEntityManager(commandContext).findAll();
        //
        //Map<string, string> properties = new HashMap<>();
        //for (IdmPropertyEntity propertyEntity : propertyEntities) {
        //    properties.put(propertyEntity.getName(), propertyEntity.getValue());
        //}
        //return properties;
    }

}
