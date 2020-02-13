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



import java.io.Serializable;

/**
 * @author Joram Barrez
 * @author Tijs Rademakers
 */
class EventSubscriptionDeclaration implements Serializable {

    private static final long serialVersionUID = 1L;

    protected final string eventName;
    protected final string eventType;

    protected bool async;
    protected string activityId;
    protected bool isStartEvent;
    protected string configuration;

    public EventSubscriptionDeclaration(string eventName, string eventType) {
        this.eventName = eventName;
        this.eventType = eventType;
    }

    public string getEventName() {
        return eventName;
    }

    public bool isAsync() {
        return async;
    }

    public void setAsync(bool async) {
        this.async = async;
    }

    public void setActivityId(string activityId) {
        this.activityId = activityId;
    }

    public string getActivityId() {
        return activityId;
    }

    public bool isStartEvent() {
        return isStartEvent;
    }

    public void setStartEvent(bool isStartEvent) {
        this.isStartEvent = isStartEvent;
    }

    public string getEventType() {
        return eventType;
    }

    public string getConfiguration() {
        return configuration;
    }

    public void setConfiguration(string configuration) {
        this.configuration = configuration;
    }
}
