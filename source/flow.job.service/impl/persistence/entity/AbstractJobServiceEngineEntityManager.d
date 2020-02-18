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


import flow.common.api.deleg.event.FlowableEngineEventType;
import flow.common.api.deleg.event.FlowableEntityEvent;
import flow.common.persistence.entity.AbstractServiceEngineEntityManager;
import flow.common.persistence.entity.Entity;
import flow.common.persistence.entity.data.DataManager;
import org.flowable.job.service.JobServiceConfiguration;
import org.flowable.job.service.event.impl.FlowableJobEventBuilder;

/**
 * @author Joram Barrez
 */
public abstract class AbstractJobServiceEngineEntityManager<EntityImpl extends Entity, DM extends DataManager<EntityImpl>>
    extends AbstractServiceEngineEntityManager<JobServiceConfiguration, EntityImpl, DM> {

    public AbstractJobServiceEngineEntityManager(JobServiceConfiguration variableServiceConfiguration, DM dataManager) {
        super(variableServiceConfiguration, dataManager);
    }

    @Override
    protected FlowableEntityEvent createEntityEvent(FlowableEngineEventType eventType, Entity entity) {
        return FlowableJobEventBuilder.createEntityEvent(eventType, entity);
    }

    protected void deleteByteArrayRef(JobByteArrayRef jobByteArrayRef) {
        if(jobByteArrayRef !is null) {
            jobByteArrayRef.delete();
        }
    }
}
