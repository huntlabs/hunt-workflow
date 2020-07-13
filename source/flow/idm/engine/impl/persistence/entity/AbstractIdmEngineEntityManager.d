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
module flow.idm.engine.impl.persistence.entity.AbstractIdmEngineEntityManager;

import flow.common.api.deleg.event.FlowableEngineEventType;
import flow.common.api.deleg.event.FlowableEntityEvent;
import flow.common.persistence.entity.AbstractEngineEntityManager;
import flow.common.persistence.entity.Entity;
import flow.common.persistence.entity.data.DataManager;
import flow.idm.api.event.FlowableIdmEventType;
import flow.idm.engine.IdmEngineConfiguration;
import flow.idm.engine.deleg.event.impl.FlowableIdmEventBuilder;
/**
 * @author Joram Barrez
 */
abstract class AbstractIdmEngineEntityManager(EntityImpl , DM)
    : AbstractEngineEntityManager!(IdmEngineConfiguration, EntityImpl, DM) {

    this(IdmEngineConfiguration idmEngineConfiguration, DM dataManager) {
        super(idmEngineConfiguration, dataManager);
    }


    override
    protected FlowableEntityEvent createEntityEvent(FlowableEngineEventType eventType, Entity entity) {
        FlowableIdmEventType idmEventType;
        //switch (eventType) {
            if (eventType == FlowableEngineEventType.ENTITY_CREATED)
                idmEventType = FlowableIdmEventType.ENTITY_CREATED;
            else if(eventType == FlowableEngineEventType.ENTITY_INITIALIZED)
                idmEventType = FlowableIdmEventType.ENTITY_INITIALIZED;
            else if(eventType == FlowableEngineEventType.ENTITY_UPDATED)
                idmEventType = FlowableIdmEventType.ENTITY_UPDATED;
            else if(eventType == FlowableEngineEventType.ENTITY_DELETED)
                idmEventType = FlowableIdmEventType.ENTITY_DELETED;
            else
                idmEventType = null;
        //}

        if (idmEventType !is null) {
            return FlowableIdmEventBuilder.createEntityEvent(idmEventType, cast(Object)entity);
        } else {
            return super.createEntityEvent(eventType, entity);
        }
    }
}
