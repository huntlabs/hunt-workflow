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
module flow.engine.impl.persistence.entity.data.ActivityInstanceDataManager;

import hunt.collection.List;
import hunt.collection.Map;

import flow.common.persistence.entity.data.DataManager;
import flow.engine.impl.ActivityInstanceQueryImpl;
import flow.engine.impl.persistence.entity.ActivityInstanceEntity;
import flow.engine.runtime.ActivityInstance;

/**
 * @author martin.grofcik
 */
interface ActivityInstanceDataManager : DataManager!ActivityInstanceEntity {

    List!ActivityInstanceEntity findUnfinishedActivityInstancesByExecutionAndActivityId(string executionId, string activityId);

    List!ActivityInstanceEntity findActivityInstancesByExecutionIdAndActivityId(string executionId, string activityId);

    void deleteActivityInstancesByProcessInstanceId(string processInstanceId);

    long findActivityInstanceCountByQueryCriteria(ActivityInstanceQueryImpl activityInstanceQuery);

    List!ActivityInstance findActivityInstancesByQueryCriteria(ActivityInstanceQueryImpl activityInstanceQuery);

    List!ActivityInstance findActivityInstancesByNativeQuery(Map!(string, Object) parameterMap);

    long findActivityInstanceCountByNativeQuery(Map!(string, Object) parameterMap);
}
