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
module flow.job.service.impl.persistence.entity.AbstractJobServiceEngineEntityManager;

import flow.common.api.deleg.event.FlowableEngineEventType;
import flow.common.api.deleg.event.FlowableEntityEvent;
import flow.common.persistence.entity.AbstractServiceEngineEntityManager;
import flow.common.persistence.entity.Entity;
import flow.common.persistence.entity.data.DataManager;
import flow.job.service.JobServiceConfiguration;
import flow.job.service.event.impl.FlowableJobEventBuilder;

/**
 * @author Joram Barrez
 */
class AbstractJobServiceEngineEntityManager(EntityImpl, DM)
    : AbstractServiceEngineEntityManager!(JobServiceConfiguration, EntityImpl, DM) {

    this(JobServiceConfiguration variableServiceConfiguration, DM dataManager) {
        super(variableServiceConfiguration, dataManager);
    }

    override
    protected FlowableEntityEvent createEntityEvent(FlowableEngineEventType eventType, Entity entity) {
        return FlowableJobEventBuilder.createEntityEvent(eventType, entity);
    }

    protected void deleteByteArrayRef(JobByteArrayRef jobByteArrayRef) {
        if(jobByteArrayRef !is null) {
            jobByteArrayRef.dele();
        }
    }
}
