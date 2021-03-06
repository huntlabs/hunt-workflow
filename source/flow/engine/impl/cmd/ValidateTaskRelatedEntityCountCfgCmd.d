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
module flow.engine.impl.cmd.ValidateTaskRelatedEntityCountCfgCmd;

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
class ValidateTaskRelatedEntityCountCfgCmd : Command!Void {


    public static  string PROPERTY_TASK_RELATED_ENTITY_COUNT = "cfg.task-related-entities-count";

    public Void execute(CommandContext commandContext) {

        PropertyEntityManager propertyEntityManager = CommandContextUtil.getPropertyEntityManager(commandContext);

        bool configProperty = CommandContextUtil.getProcessEngineConfiguration(commandContext).getPerformanceSettings().isEnableTaskRelationshipCounts();
        PropertyEntity propertyEntity = propertyEntityManager.findById(PROPERTY_TASK_RELATED_ENTITY_COUNT);

        if (propertyEntity is null) {
            // 'not there' case in the table above: easy, simply insert the value

            PropertyEntity newPropertyEntity = propertyEntityManager.create();
            newPropertyEntity.setName(PROPERTY_TASK_RELATED_ENTITY_COUNT);
            newPropertyEntity.setValue(to!string(configProperty));
            propertyEntityManager.insert(newPropertyEntity);

        } else {

            bool propertyValue = to!bool(propertyEntity.getValue());
            // TODO: is this required since we check the global "task count" flag each time we read/update?
            // might have a serious performance impact when thousands of tasks are present.
            if (!configProperty && propertyValue) {
                //if (LOGGER.isInfoEnabled()) {
                //    LOGGER.info("Configuration change: task related entity counting feature was enabled before, but now disabled. "
                //            + "Updating all task entities.");
                //}
                CommandContextUtil.getTaskService().updateAllTaskRelatedEntityCountFlags(configProperty);
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
