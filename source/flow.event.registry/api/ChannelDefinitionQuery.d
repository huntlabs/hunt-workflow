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

module flow.event.registry.api.ChannelDefinitionQuery;

import hunt.time.LocalDateTime;;
import hunt.collection.Set;
import flow.event.registry.api.ChannelDefinition;
import flow.common.api.FlowableIllegalArgumentException;
import flow.common.api.query.Query;

alias Date = LocalDateTime;

/**
 * Allows programmatic querying of {@link ChannelDefinition}s.
 *
 * @author Tijs Rademakers
 * @author Joram Barrez
 */
interface ChannelDefinitionQuery : Query!(ChannelDefinitionQuery, ChannelDefinition) {

    /** Only select channel definition with the given id. */
    ChannelDefinitionQuery channelDefinitionId(string channelDefinitionId);

    /** Only select channel definitions with the given ids. */
    ChannelDefinitionQuery channelDefinitionIds(Set!string channelDefinitionIds);

    /** Only select channel definitions with the given category. */
    ChannelDefinitionQuery channelCategory(string category);

    /**
     * Only select channel definitions where the category matches the given parameter. The syntax that should be used is the same as in SQL, eg. %test%
     */
    ChannelDefinitionQuery channelCategoryLike(string categoryLike);

    /**
     * Only select channel definitions that have a different category then the given one.
     */
    ChannelDefinitionQuery channelCategoryNotEquals(string categoryNotEquals);

    /** Only select channel definitions with the given name. */
    ChannelDefinitionQuery channelDefinitionName(string channelDefinitionName);

    /**
     * Only select channel definitions where the name matches the given parameter. The syntax that should be used is the same as in SQL, eg. %test%
     */
    ChannelDefinitionQuery channelDefinitionNameLike(string channelDefinitionNameLike);

    /**
     * Only select channel definitions that are deployed in a deployment with the given deployment id
     */
    ChannelDefinitionQuery deploymentId(string deploymentId);

    /**
     * Select channel definitions that are deployed in deployments with the given set of ids
     */
    ChannelDefinitionQuery deploymentIds(Set!string deploymentIds);

    /**
     * Only select channel definition with the given key.
     */
    ChannelDefinitionQuery channelDefinitionKey(string channelDefinitionKey);

    /**
     * Only select channel definitions where the key matches the given parameter. The syntax that should be used is the same as in SQL, eg. %test%
     */
    ChannelDefinitionQuery channelDefinitionKeyLike(string channelDefinitionKeyLike);

    /**
     * Only select channel definitions with a certain version. Particularly useful when used in combination with {@link #formDefinitionKey(string)}
     */
    ChannelDefinitionQuery channelVersion(int channelVersion);

    /**
     * Only select channel definitions which version are greater than a certain version.
     */
    ChannelDefinitionQuery channelVersionGreaterThan(int channelVersion);

    /**
     * Only select channel definitions which version are greater than or equals a certain version.
     */
    ChannelDefinitionQuery channelVersionGreaterThanOrEquals(int channelVersion);

    /**
     * Only select channel definitions which version are lower than a certain version.
     */
    ChannelDefinitionQuery channelVersionLowerThan(int channelVersion);

    /**
     * Only select channel definitions which version are lower than or equals a certain version.
     */
    ChannelDefinitionQuery channelVersionLowerThanOrEquals(int channelVersion);

    /**
     * Only select the channel definitions which are the latest deployed (ie. which have the highest version number for the given key).
     *
     * Can also be used without any other criteria (ie. query.latestVersion().list()), which will then give all the latest versions of all the deployed channel definitions.
     *
     * @throws FlowableIllegalArgumentException
     *             if used in combination with {{@link #channelVersion(int)} or {@link #deploymentId(string)}
     */
    ChannelDefinitionQuery latestVersion();

    /**
     * Only select channel definitions where the create time is equal to a certain date.
     */
    ChannelDefinitionQuery channelCreateTime(Date createTime);

    /**
     * Only select channel definitions which create time is after a certain date.
     */
    ChannelDefinitionQuery channelCreateTimeAfter(Date createTimeAfter);

    /**
     * Only select channel definitions which create time is before a certain date.
     */
    ChannelDefinitionQuery channelCreateTimeBefore(Date createTimeBefore);

    /** Only select channel definition with the given resource name. */
    ChannelDefinitionQuery channelDefinitionResourceName(string resourceName);

    /** Only select channel definition with a resource name like the given . */
    ChannelDefinitionQuery channelDefinitionResourceNameLike(string resourceNameLike);

    /**
     * Only select channel definitions that have the given tenant id.
     */
    ChannelDefinitionQuery tenantId(string tenantId);

    /**
     * Only select channel definitions with a tenant id like the given one.
     */
    ChannelDefinitionQuery tenantIdLike(string tenantIdLike);

    /**
     * Only select channel definitions that do not have a tenant id.
     */
    ChannelDefinitionQuery withoutTenantId();

    // ordering ////////////////////////////////////////////////////////////

    /**
     * Order by the category of the channel definitions (needs to be followed by {@link #asc()} or {@link #desc()}).
     */
    ChannelDefinitionQuery orderByChannelDefinitionCategory();

    /**
     * Order by channel definition key (needs to be followed by {@link #asc()} or {@link #desc()}).
     */
    ChannelDefinitionQuery orderByChannelDefinitionKey();

    /**
     * Order by the id of the channel definitions (needs to be followed by {@link #asc()} or {@link #desc()}).
     */
    ChannelDefinitionQuery orderByChannelDefinitionId();

    /**
     * Order by the name of the channel definitions (needs to be followed by {@link #asc()} or {@link #desc()}).
     */
    ChannelDefinitionQuery orderByChannelDefinitionName();

    /**
     * Order by deployment id (needs to be followed by {@link #asc()} or {@link #desc()}).
     */
    ChannelDefinitionQuery orderByDeploymentId();

    /**
     * Order by create time (needs to be followed by {@link #asc()} or {@link #desc()}).
     */
    ChannelDefinitionQuery orderByCreateTime();

    /**
     * Order by tenant id (needs to be followed by {@link #asc()} or {@link #desc()}).
     */
    ChannelDefinitionQuery orderByTenantId();

}
