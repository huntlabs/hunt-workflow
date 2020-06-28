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
//          Copyright linse 2020.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)}

module flow.engine.deleg.event.impl.FlowableJobRescheduledEventImpl;





import flow.common.api.deleg.event.FlowableEngineEventType;
import flow.engine.deleg.event.FlowableJobRescheduledEvent;
import flow.job.service.api.Job;
import flow.engine.deleg.event.impl.FlowableEntityEventImpl;

class FlowableJobRescheduledEventImpl : FlowableEntityEventImpl , FlowableJobRescheduledEvent {

    /**
     * The id of the original job that was rescheduled.
     */
    protected string rescheduledJobId;

    this(Job entity, string rescheduledJobId, FlowableEngineEventType type) {
        super(cast(Object)entity, type);
        this.rescheduledJobId = rescheduledJobId;
    }

    public string getRescheduledJobId() {
        return rescheduledJobId;
    }
}
