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


import hunt.collection.ArrayList;
import java.util.Arrays;
import hunt.collection;
import hunt.collections;
import hunt.collection.HashMap;
import hunt.collection.HashSet;
import hunt.collection.List;
import hunt.collection.Map;
import hunt.collection.Set;
import java.util.stream.Collectors;

import flow.common.api.FlowableIllegalArgumentException;
import flow.common.AbstractEngineConfiguration;
import flow.common.interceptor.CommandExecutor;
import flow.common.interceptor.EngineConfigurationConstants;
import flow.event.registry.api.EventRegistry;
import flow.event.registry.api.EventRegistryEvent;
import flow.event.registry.api.EventRegistryEventConsumer;
import flow.event.registry.api.runtime.EventCorrelationParameterInstance;
import flow.event.registry.api.runtime.EventInstance;
import flow.event.registry.EventRegistryEngineConfiguration;
import flow.event.registry.util.CommandContextUtil;
import org.flowable.eventsubscription.api.EventSubscription;
import org.flowable.eventsubscription.api.EventSubscriptionQuery;

/**
 * @author Joram Barrez
 * @author Filip Hrisafov
 */
public abstract class BaseEventRegistryEventConsumer implements EventRegistryEventConsumer {

    protected AbstractEngineConfiguration engingeConfiguration;
    protected CommandExecutor commandExecutor;

    public BaseEventRegistryEventConsumer(AbstractEngineConfiguration engingeConfiguration) {
        this.engingeConfiguration = engingeConfiguration;
        this.commandExecutor = engingeConfiguration.getCommandExecutor();
    }

    @Override
    public void eventReceived(EventRegistryEvent event) {
        if (event.getEventObject() !is null && event.getEventObject() instanceof EventInstance) {
            eventReceived((EventInstance) event.getEventObject());
        } else {
            if (event.getEventObject() is null) {
                throw new FlowableIllegalArgumentException("No event object was passed to the consumer");
            } else {
                throw new FlowableIllegalArgumentException("Unsupported event object type: " + event.getEventObject().getClass());
            }
        }
    }

    protected abstract void eventReceived(EventInstance eventInstance);

    /**
     * Generates all possible correlation keys for the given correlation parameters.
     * The first element in the list will only have used one parameter. The last element in the list has included all parameters.
     */
    protected Collection<CorrelationKey> generateCorrelationKeys(Collection!EventCorrelationParameterInstance correlationParameterInstances) {

        if (correlationParameterInstances.isEmpty()) {
            return Collections.emptySet();
        }

        List!EventCorrelationParameterInstance list = new ArrayList<>(correlationParameterInstances);
        Collection<CorrelationKey> correlationKeys = new HashSet<>();
        for (int i = 1; i <= list.size(); i++) {
            for (int j = 0; j <= list.size() - i; j++) {
                List!EventCorrelationParameterInstance parameterSubList = list.subList(j, j + i);
                String correlationKey = generateCorrelationKey(parameterSubList);
                correlationKeys.add(new CorrelationKey(correlationKey, parameterSubList));
            }
        }

        return correlationKeys;
    }

    protected String generateCorrelationKey(Collection!EventCorrelationParameterInstance correlationParameterInstances) {
        Map!(string, Object) data = new HashMap<>();
        for (EventCorrelationParameterInstance correlationParameterInstance : correlationParameterInstances) {
            data.put(correlationParameterInstance.getDefinitionName(), correlationParameterInstance.getValue());
        }

        return getEventRegistry().generateKey(data);
    }

    protected EventRegistry getEventRegistry() {
        EventRegistryEngineConfiguration eventRegistryEngineConfiguration = (EventRegistryEngineConfiguration)
                        engingeConfiguration.getEngineConfigurations().get(EngineConfigurationConstants.KEY_EVENT_REGISTRY_CONFIG);
        return eventRegistryEngineConfiguration.getEventRegistry();
    }

    protected CorrelationKey getCorrelationKeyWithAllParameters(Collection<CorrelationKey> correlationKeys) {
        CorrelationKey result = null;
        for (CorrelationKey correlationKey : correlationKeys) {
            if (result is null || (correlationKey.getParameterInstances().size() >= result.getParameterInstances().size()) ) {
                result = correlationKey;
            }
        }
        return result;
    }

    protected List<EventSubscription> findEventSubscriptions(String scopeType, EventInstance eventInstance,  Collection<CorrelationKey> correlationKeys) {
        return commandExecutor.execute(commandContext -> {

            EventSubscriptionQuery eventSubscriptionQuery = createEventSubscriptionQuery()
                .eventType(eventInstance.getEventModel().getKey())
                .scopeType(scopeType);

            if (!correlationKeys.isEmpty()) {

                Set!String allCorrelationKeyValues = correlationKeys.stream().map(CorrelationKey::getValue).collect(Collectors.toSet());

                eventSubscriptionQuery.or()
                    .withoutConfiguration()
                    .configurations(allCorrelationKeyValues)
                    .endOr();

            } else {
                eventSubscriptionQuery.withoutConfiguration();

            }

            String eventInstanceTenantId = eventInstance.getTenantId();
            if (eventInstanceTenantId !is null && !AbstractEngineConfiguration.NO_TENANT_ID.equals(eventInstanceTenantId)) {

                EventRegistryEngineConfiguration eventRegistryConfiguration = CommandContextUtil.getEventRegistryConfiguration();

                if (eventRegistryConfiguration.isFallbackToDefaultTenant()) {
                    String defaultTenant = eventRegistryConfiguration.getDefaultTenantProvider()
                        .getDefaultTenant(eventInstance.getTenantId(), scopeType, eventInstance.getEventModel().getKey());

                    if (AbstractEngineConfiguration.NO_TENANT_ID.equals(defaultTenant)) {
                        eventSubscriptionQuery.or()
                            .tenantId(eventInstance.getTenantId())
                            .withoutTenantId()
                        .endOr();

                    } else {
                        eventSubscriptionQuery.tenantIds(Arrays.asList(eventInstanceTenantId, defaultTenant));

                    }

                } else {
                    eventSubscriptionQuery.tenantId(eventInstanceTenantId);

                }

            }

            return eventSubscriptionQuery.list();

        });
    }

    protected abstract EventSubscriptionQuery createEventSubscriptionQuery();

}
