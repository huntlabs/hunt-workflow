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

module flow.common.persistence.entity.AbstractEntityManager;

import flow.common.api.deleg.event.FlowableEngineEventType;
import flow.common.api.deleg.event.FlowableEntityEvent;
import flow.common.api.deleg.event.FlowableEventDispatcher;
import flow.common.event.FlowableEntityEventImpl;
import flow.common.persistence.entity.data.DataManager;
import flow.common.persistence.entity.EntityManager;
import flow.common.persistence.entity.Entity;
/**
 * @author Joram Barrez
 * @author Filip Hrisafov
 */
abstract class AbstractEntityManager(EntityImpl , DM )
    : EntityManager!EntityImpl {

    protected DM dataManager;

    this(DM dataManager) {
        this.dataManager = dataManager;
    }

    /*
     * CRUD operations
     */


    public EntityImpl findById(string entityId) {
        return getDataManager().findById(entityId);
    }


    public EntityImpl create() {
        return getDataManager().create();
    }


    public void insert(EntityImpl entity) {
        insert(entity, true);
    }


    public void insert(EntityImpl entity, bool fireCreateEvent) {
        getDataManager().insert(entity);
        if (fireCreateEvent) {
            fireEntityInsertedEvent(entity);
        }
    }

    protected void fireEntityInsertedEvent(Entity entity) {
        FlowableEventDispatcher eventDispatcher = getEventDispatcher();
        if (eventDispatcher !is null && eventDispatcher.isEnabled()) {
            eventDispatcher.dispatchEvent(createEntityEvent(FlowableEngineEventType.ENTITY_CREATED, entity));
            eventDispatcher.dispatchEvent(createEntityEvent(FlowableEngineEventType.ENTITY_INITIALIZED, entity));
        }
    }


    public EntityImpl update(EntityImpl entity) {
        return update(entity, true);
    }


    public EntityImpl update(EntityImpl entity, bool fireUpdateEvent) {
        EntityImpl updatedEntity = getDataManager().update(entity);
        if (fireUpdateEvent) {
            fireEntityUpdatedEvent(entity);
        }
        return updatedEntity;
    }

    protected void fireEntityUpdatedEvent(Entity entity) {
        FlowableEventDispatcher eventDispatcher = getEventDispatcher();
        if (eventDispatcher !is null && eventDispatcher.isEnabled()) {
            getEventDispatcher().dispatchEvent(createEntityEvent(FlowableEngineEventType.ENTITY_UPDATED, entity));
        }
    }


    public void dele(string id) {
        EntityImpl entity = findById(id);
        dele(entity);
    }


    public void dele(EntityImpl entity) {
        dele(entity, true);
    }


    public void dele(EntityImpl entity, bool fireDeleteEvent) {
        getDataManager().dele(entity);

        FlowableEventDispatcher eventDispatcher = getEventDispatcher();
        if (fireDeleteEvent && eventDispatcher !is null && eventDispatcher.isEnabled()) {
            fireEntityDeletedEvent(entity);
        }
    }

    protected void fireEntityDeletedEvent(Entity entity) {
        FlowableEventDispatcher eventDispatcher = getEventDispatcher();
        if (eventDispatcher !is null && eventDispatcher.isEnabled()) {
            eventDispatcher.dispatchEvent(createEntityEvent(FlowableEngineEventType.ENTITY_DELETED, entity));
        }
    }

    protected FlowableEntityEvent createEntityEvent(FlowableEngineEventType eventType, Entity entity) {
        return new FlowableEntityEventImpl(entity, eventType);
    }

    protected DM getDataManager() {
        return dataManager;
    }

    protected void setDataManager(DM dataManager) {
        this.dataManager = dataManager;
    }

    protected abstract FlowableEventDispatcher getEventDispatcher();

}
