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


    override
    public void setConfiguration(string configuration) {
        if (configuration !is null && configuration.contains("{\"scope\":")) {
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
            return  this.configuration[10 .. this.configuration.length() - 2];
           // return this.configuration.substring(10, this.configuration.length() - 2); // 10 --> length of {"scope": and -2 for removing"}
        }
    }

}
