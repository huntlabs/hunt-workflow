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

module flow.eventsubscription.service.impl.persistence.entity.SignalEventSubscriptionEntityImpl;

//import java.text.MessageFormat;
import std.string;
import flow.bpmn.model.Signal;
import flow.eventsubscription.service.impl.persistence.entity.SignalEventSubscriptionEntity;
import flow.eventsubscription.service.impl.persistence.entity.EventSubscriptionEntityImpl;
import hunt.Exceptions;
/**
 * @author Joram Barrez
 * @author Tijs Rademakers
 */
class SignalEventSubscriptionEntityImpl : EventSubscriptionEntityImpl , SignalEventSubscriptionEntity {


    // Using json here, but not worth of adding json dependency lib for this
    private static  string CONFIGURATION_TEMPLATE = "'{'\"scope\":\"{0}\"'}'";

    this() {
        eventType = EVENT_TYPE;
    }

    override string getId()
    {
      return super.getId;
    }

    override Object getPersistentState()
    {
      return super.getPersistentState;
    }

    override void setId(string id)
    {
      super.setId(id);
    }

    override
    public void setConfiguration(string configuration) {
        if (configuration !is null && configuration.indexOf("{\"scope\":") != -1) {
            this.configuration = configuration;
        } else {
            implementationMissing(false);
           // this.configuration = MessageFormat.format(CONFIGURATION_TEMPLATE, configuration);
        }
    }


    public bool isProcessInstanceScoped() {
        string scop = extractScopeFormConfiguration();
        return Signal.SCOPE_PROCESS_INSTANCE == (scop);
    }


    public bool isGlobalScoped() {
        string scop = extractScopeFormConfiguration();
        return (scop is null) || Signal.SCOPE_GLOBAL == (scop);
    }

    protected string extractScopeFormConfiguration() {
        if (this.configuration is null) {
            return null;
        } else {
            return  this.configuration[10 .. this.configuration.length - 2];
           // return this.configuration.substring(10, this.configuration.length() - 2); // 10 --> length of {"scope": and -2 for removing"}
        }
    }


    override
    string getIdPrefix()
    {
      return super.getIdPrefix;
    }

    override
    bool isInserted()
    {
      return super.isInserted();
    }

    override
    void setInserted(bool inserted)
    {
      return super.setInserted(inserted);
    }

    override
    bool isUpdated()
    {
      return super.isUpdated;
    }

    override
    void setUpdated(bool updated)
    {
      super.setUpdated(updated);
    }

    override
    bool isDeleted()
    {
      return super.isDeleted;
    }

    override
    void setDeleted(bool deleted)
    {
      super.setDeleted(deleted);
    }

    override
    Object getOriginalPersistentState()
    {
      return super.getOriginalPersistentState;
    }

    override
    void setOriginalPersistentState(Object persistentState)
    {
      super.setOriginalPersistentState(persistentState);
    }

    override
    void setRevision(int revision)
    {
      super.setRevision(revision);
    }

    override
    int getRevision()
    {
      return super.getRevision;
    }


    override
    int getRevisionNext()
    {
      return super.getRevisionNext;
    }

}
