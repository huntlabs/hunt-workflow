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

module flow.engine.deleg.event.impl.FlowableSequenceFlowTakenEventImpl;





import flow.common.api.deleg.event.FlowableEngineEventType;
import flow.engine.deleg.event.FlowableSequenceFlowTakenEvent;
import flow.engine.deleg.event.impl.FlowableProcessEventImpl;

/**
 * @author Joram Barrez
 */
class FlowableSequenceFlowTakenEventImpl : FlowableProcessEventImpl , FlowableSequenceFlowTakenEvent {

    protected string id;
    protected string sourceActivityId;
    protected string sourceActivityName;
    protected string sourceActivityType;
    protected string targetActivityId;
    protected string targetActivityName;
    protected string targetActivityType;
    protected string sourceActivityBehaviorClass;
    protected string targetActivityBehaviorClass;

    this(FlowableEngineEventType type) {
        super(type);
    }


    public string getId() {
        return id;
    }

    public void setId(string id) {
        this.id = id;
    }


    public string getSourceActivityId() {
        return sourceActivityId;
    }

    public void setSourceActivityId(string sourceActivityId) {
        this.sourceActivityId = sourceActivityId;
    }


    public string getSourceActivityName() {
        return sourceActivityName;
    }

    public void setSourceActivityName(string sourceActivityName) {
        this.sourceActivityName = sourceActivityName;
    }


    public string getSourceActivityType() {
        return sourceActivityType;
    }

    public void setSourceActivityType(string sourceActivityType) {
        this.sourceActivityType = sourceActivityType;
    }


    public string getTargetActivityId() {
        return targetActivityId;
    }

    public void setTargetActivityId(string targetActivityId) {
        this.targetActivityId = targetActivityId;
    }


    public string getTargetActivityName() {
        return targetActivityName;
    }

    public void setTargetActivityName(string targetActivityName) {
        this.targetActivityName = targetActivityName;
    }


    public string getTargetActivityType() {
        return targetActivityType;
    }

    public void setTargetActivityType(string targetActivityType) {
        this.targetActivityType = targetActivityType;
    }


    public string getSourceActivityBehaviorClass() {
        return sourceActivityBehaviorClass;
    }

    public void setSourceActivityBehaviorClass(string sourceActivityBehaviorClass) {
        this.sourceActivityBehaviorClass = sourceActivityBehaviorClass;
    }


    public string getTargetActivityBehaviorClass() {
        return targetActivityBehaviorClass;
    }

    public void setTargetActivityBehaviorClass(string targetActivityBehaviorClass) {
        this.targetActivityBehaviorClass = targetActivityBehaviorClass;
    }

}
