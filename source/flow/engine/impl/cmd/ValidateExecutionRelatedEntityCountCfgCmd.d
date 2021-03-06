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
module flow.engine.impl.cmd.ValidateExecutionRelatedEntityCountCfgCmd;

import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.common.persistence.entity.PropertyEntity;
import flow.common.persistence.entity.PropertyEntityManager;
import flow.engine.impl.util.CommandContextUtil;
import hunt.Object;
import std.conv : to;
/**
 * @author Joram Barrez
 */
class ValidateExecutionRelatedEntityCountCfgCmd : Command!Void {


    public static  string PROPERTY_EXECUTION_RELATED_ENTITY_COUNT = "cfg.execution-related-entities-count";

    public Void execute(CommandContext commandContext) {

        /*
         * If execution related entity counting is on in config | Current property in database : Result
         *
         * A) true | not there : write new property with value 'true'
         *
         * B) true | true : all good
         *
         * C) true | false : the feature was disabled before, but it is enabled now. Old executions will have a
         * local flag with false. It is now enabled. This is fine, will be handled in logic. Update the property.
         *
         * D) false | not there: write new property with value 'false'
         *
         * E) false | true : the feature was disabled before and enabled now.
         * To guarantee data consistency, we need to remove the flag from all executions. Update the property.
         *
         * F) false | false : all good
         *
         * In case A and D (not there), the property needs to be written to the db Only in case E something needs to be done explicitly, the others are okay.
         */

        PropertyEntityManager propertyEntityManager = CommandContextUtil.getPropertyEntityManager(commandContext);

        bool configProperty = CommandContextUtil.getProcessEngineConfiguration(commandContext).getPerformanceSettings().isEnableExecutionRelationshipCounts();
        PropertyEntity propertyEntity = propertyEntityManager.findById(PROPERTY_EXECUTION_RELATED_ENTITY_COUNT);

        if (propertyEntity is null) {

            // 'not there' case in the table above: easy, simply insert the value

            PropertyEntity newPropertyEntity = propertyEntityManager.create();
            newPropertyEntity.setName(PROPERTY_EXECUTION_RELATED_ENTITY_COUNT);
            newPropertyEntity.setValue(to!string(configProperty));
            propertyEntityManager.insert(newPropertyEntity);

        } else {

            bool propertyValue = to!bool(propertyEntity.getValue());
            if (!configProperty && propertyValue) {
                //if (LOGGER.isInfoEnabled()) {
                //    LOGGER.info("Configuration change: execution related entity counting feature was enabled before, but now disabled. "
                //            + "Updating all execution entities.");
                //}
                CommandContextUtil.getProcessEngineConfiguration(commandContext).getExecutionDataManager().updateAllExecutionRelatedEntityCountFlags(configProperty);
            }

            // Update property
            if (configProperty != propertyValue) {
                propertyEntity.setValue(to!string(configProperty));
                propertyEntityManager.update(propertyEntity);
            }

        }

        return null;
    }

}
