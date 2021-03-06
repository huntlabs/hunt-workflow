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
module flow.engine.impl.persistence.entity.AbstractProcessEngineEntityManager;

import flow.common.api.deleg.event.FlowableEngineEventType;
import flow.common.api.deleg.event.FlowableEntityEvent;
import flow.common.persistence.entity.AbstractEngineEntityManager;
import flow.common.persistence.entity.Entity;
import flow.common.persistence.entity.data.DataManager;
import flow.engine.deleg.event.impl.FlowableEventBuilder;
import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;

/**
 * @author Joram Barrez
 */
abstract class AbstractProcessEngineEntityManager(EntityImpl, DM)
    : AbstractEngineEntityManager!(ProcessEngineConfigurationImpl, EntityImpl, DM) {

    this(ProcessEngineConfigurationImpl processEngineConfiguration, DM dataManager) {
        super(processEngineConfiguration, dataManager);
    }

    override
    protected FlowableEntityEvent createEntityEvent(FlowableEngineEventType eventType, Entity entity) {
        return FlowableEventBuilder.createEntityEvent(eventType, cast(Object)entity);
    }
}
