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

module flow.common.cmd.GetPropertiesCmd;

import hunt.collection.HashMap;
import hunt.collection.List;
import hunt.collection.Map;

import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.common.persistence.entity.PropertyEntity;

/**
 * @author Tom Baeyens
 */
public class GetPropertiesCmd : Command!(Map!(string, string)) {


    public Map!(string, string) execute(CommandContext commandContext) {
        List!PropertyEntity propertyEntities = commandContext.getCurrentEngineConfiguration().getPropertyEntityManager().findAll();

        Map!(string, string) properties = new HashMap!(string, string)();
        foreach (PropertyEntity propertyEntity ; propertyEntities) {
            properties.put(propertyEntity.getName(), propertyEntity.getValue());
        }
        return properties;
    }

}
