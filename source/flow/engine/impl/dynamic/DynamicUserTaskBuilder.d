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
module flow.engine.impl.dynamic.DynamicUserTaskBuilder;

import hunt.collection.Map;
import std.conv : to;
import flow.bpmn.model.FlowElement;
import flow.engine.impl.dynamic.DynamicUserTaskCallback;

class DynamicUserTaskBuilder {

    protected string _id;
    protected string _name;
    protected string _assignee;
    protected DynamicUserTaskCallback _dynamicUserTaskCallback;
    protected string dynamicTaskId;
    protected int counter = 1;

    this() {

    }

    this(string id) {
        this._id = id;
    }

    public string getId() {
        return _id;
    }

    public void setId(string id) {
        this._id = id;
    }

    public DynamicUserTaskBuilder id(string id) {
        this._id = id;
        return this;
    }

    public string getName() {
        return _name;
    }

    public void setName(string name) {
        this._name = name;
    }

    public DynamicUserTaskBuilder name(string name) {
        this._name = name;
        return this;
    }

    public string getAssignee() {
        return _assignee;
    }

    public void setAssignee(string assignee) {
        this._assignee = assignee;
    }

    public DynamicUserTaskBuilder assignee(string assignee) {
        this._assignee = assignee;
        return this;
    }

    public DynamicUserTaskCallback getDynamicUserTaskCallback() {
        return _dynamicUserTaskCallback;
    }

    public void setDynamicUserTaskCallback(DynamicUserTaskCallback dynamicUserTaskCallback) {
        this._dynamicUserTaskCallback = dynamicUserTaskCallback;
    }

    public DynamicUserTaskBuilder dynamicUserTaskCallback(DynamicUserTaskCallback dynamicUserTaskCallback) {
        this._dynamicUserTaskCallback = dynamicUserTaskCallback;
        return this;
    }

    public string getDynamicTaskId() {
        return dynamicTaskId;
    }

    public void setDynamicTaskId(string dynamicTaskId) {
        this.dynamicTaskId = dynamicTaskId;
    }

    public string nextSubProcessId(Map!(string, FlowElement) flowElementMap) {
        return nextId("dynamicSubProcess", flowElementMap);
    }

    public string nextTaskId(Map!(string, FlowElement) flowElementMap) {
        return nextId("dynamicTask", flowElementMap);
    }

    public string nextFlowId(Map!(string, FlowElement) flowElementMap) {
        return nextId("dynamicFlow", flowElementMap);
    }

    public string nextForkGatewayId(Map!(string, FlowElement) flowElementMap) {
        return nextId("dynamicForkGateway", flowElementMap);
    }

    public string nextJoinGatewayId(Map!(string, FlowElement) flowElementMap) {
        return nextId("dynamicJoinGateway", flowElementMap);
    }

    public string nextStartEventId(Map!(string, FlowElement) flowElementMap) {
        return nextId("startEvent", flowElementMap);
    }

    public string nextEndEventId(Map!(string, FlowElement) flowElementMap) {
        return nextId("endEvent", flowElementMap);
    }

    protected string nextId(string prefix, Map!(string, FlowElement) flowElementMap) {
        string nextId = null;
        bool nextIdNotFound = true;
        while (nextIdNotFound) {
            if (!flowElementMap.containsKey(prefix ~ to!string(counter))) {
                nextId = prefix ~ to!string(counter);
                nextIdNotFound = false;
            }

            counter++;
        }

        return nextId;
    }

}
