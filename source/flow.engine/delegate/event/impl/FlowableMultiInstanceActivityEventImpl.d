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


import flow.common.api.delegate.event.FlowableEngineEventType;
import flow.engine.delegate.event.FlowableMultiInstanceActivityEvent;

/**
 * Implementation of an {@link FlowableMultiInstanceActivityEvent}.
 *
 * @author Robert Hafner
 */

class FlowableMultiInstanceActivityEventImpl extends FlowableActivityEventImpl implements FlowableMultiInstanceActivityEvent{
    protected bool sequential;

    public FlowableMultiInstanceActivityEventImpl(FlowableEngineEventType type) {
        super(type);
    }

    public void setSequential(bool sequential) {
        this.sequential = sequential;
    }

    @Override
    public bool isSequential() {
        return false;
    }

}
