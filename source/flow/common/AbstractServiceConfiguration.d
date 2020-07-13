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

module flow.common.AbstractServiceConfiguration;





import hunt.collection.List;
import hunt.collection.Map;
import flow.common.api.deleg.event.FlowableEventDispatcher;
import flow.common.api.deleg.event.FlowableEventListener;
import flow.common.event.EventDispatchAction;
import flow.common.history.HistoryLevel;
import flow.common.runtime.Clockm;

//import com.fasterxml.jackson.databind.ObjectMapper;

/**
 * @author Tijs Rademakers
 */
abstract class AbstractServiceConfiguration {

    /** The tenant id indicating 'no tenant' */
    public static  string NO_TENANT_ID = "";

    protected string engineName;
    protected bool enableEventDispatcher = true;
    protected FlowableEventDispatcher eventDispatcher;
    protected List!FlowableEventListener eventListeners;
    protected Map!(string, List!FlowableEventListener) typedEventListeners;
    protected List!EventDispatchAction additionalEventDispatchActions;

    protected HistoryLevel historyLevel;

   // protected ObjectMapper objectMapper;

    protected Clockm clock;

    this(string engineName) {
        this.engineName = engineName;
    }

    public bool isHistoryLevelAtLeast(HistoryLevel level) {
        //if (logger.isDebugEnabled()) {
        //    logger.debug("Current history level: {}, level required: {}", historyLevel, level);
        //}
        // Comparing enums actually compares the location of values declared in the enum
        return historyLevel.isAtLeast(level);
    }

    public bool isHistoryEnabled() {
        //if (logger.isDebugEnabled()) {
        //    logger.debug("Current history level: {}", historyLevel);
        //}
        return historyLevel != HistoryLevel.NONE;
    }

    public string getEngineName() {
        return engineName;
    }

    public void setEngineName(string engineName) {
        this.engineName = engineName;
    }

    public bool isEventDispatcherEnabled() {
        return getEventDispatcher() !is null && getEventDispatcher().isEnabled();
    }

    public bool isEnableEventDispatcher() {
        return enableEventDispatcher;
    }

    public AbstractServiceConfiguration setEnableEventDispatcher(bool enableEventDispatcher) {
        this.enableEventDispatcher = enableEventDispatcher;
        return this;
    }

    public FlowableEventDispatcher getEventDispatcher() {
        return eventDispatcher;
    }

    public AbstractServiceConfiguration setEventDispatcher(FlowableEventDispatcher eventDispatcher) {
        this.eventDispatcher = eventDispatcher;
        return this;
    }

    public List!FlowableEventListener getEventListeners() {
        return eventListeners;
    }

    public AbstractServiceConfiguration setEventListeners(List!FlowableEventListener eventListeners) {
        this.eventListeners = eventListeners;
        return this;
    }

    public Map!(string, List!FlowableEventListener) getTypedEventListeners() {
        return typedEventListeners;
    }

    public AbstractServiceConfiguration setTypedEventListeners(Map!(string, List!FlowableEventListener) typedEventListeners) {
        this.typedEventListeners = typedEventListeners;
        return this;
    }

    public List!EventDispatchAction getAdditionalEventDispatchActions() {
        return additionalEventDispatchActions;
    }

    public AbstractServiceConfiguration setAdditionalEventDispatchActions(List!EventDispatchAction additionalEventDispatchActions) {
        this.additionalEventDispatchActions = additionalEventDispatchActions;
        return this;
    }

    public HistoryLevel getHistoryLevel() {
        return historyLevel;
    }

    public AbstractServiceConfiguration setHistoryLevel(HistoryLevel historyLevel) {
        this.historyLevel = historyLevel;
        return this;
    }

    //public ObjectMapper getObjectMapper() {
    //    return objectMapper;
    //}
    //
    //public AbstractServiceConfiguration setObjectMapper(ObjectMapper objectMapper) {
    //    this.objectMapper = objectMapper;
    //    return this;
    //}

    public Clockm getClock() {
        return clock;
    }

    public AbstractServiceConfiguration setClock(Clockm clock) {
        this.clock = clock;
        return this;
    }
}
