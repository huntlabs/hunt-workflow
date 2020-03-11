///* Licensed under the Apache License, Version 2.0 (the "License");
// * you may not use this file except in compliance with the License.
// * You may obtain a copy of the License at
// *
// *      http://www.apache.org/licenses/LICENSE-2.0
// *
// * Unless required by applicable law or agreed to in writing, software
// * distributed under the License is distributed on an "AS IS" BASIS,
// * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// * See the License for the specific language governing permissions and
// * limitations under the License.
// */
//
//
//import flow.common.api.FlowableIllegalArgumentException;
//import flow.common.api.FlowableObjectNotFoundException;
//import flow.common.interceptor.Command;
//import flow.common.interceptor.CommandContext;
//import flow.common.persistence.deploy.DeploymentCache;
//import flow.event.registry.persistence.deploy.ChannelDefinitionCacheEntry;
//import flow.event.registry.persistence.entity.ChannelDefinitionEntity;
//import flow.event.registry.util.CommandContextUtil;
//
///**
// * @author Tijs Rademakers
// * @author Joram Barrez
// */
//class SetChannelDefinitionCategoryCmd implements Command<Void> {
//
//    protected String channelDefinitionId;
//    protected String category;
//
//    public SetChannelDefinitionCategoryCmd(String channelDefinitionId, String category) {
//        this.channelDefinitionId = channelDefinitionId;
//        this.category = category;
//    }
//
//    @Override
//    public Void execute(CommandContext commandContext) {
//
//        if (channelDefinitionId is null) {
//            throw new FlowableIllegalArgumentException("Channel definition id is null");
//        }
//
//        ChannelDefinitionEntity channelDefinition = CommandContextUtil.getChannelDefinitionEntityManager(commandContext).findById(channelDefinitionId);
//
//        if (channelDefinition is null) {
//            throw new FlowableObjectNotFoundException("No channel definition found for id = '" + channelDefinitionId + "'");
//        }
//
//        // Update category
//        channelDefinition.setCategory(category);
//
//        // Remove channel from cache, it will be refetched later
//        DeploymentCache<ChannelDefinitionCacheEntry> channelDefinitionCache = CommandContextUtil.getEventRegistryConfiguration().getChannelDefinitionCache();
//        if (channelDefinitionCache !is null) {
//            channelDefinitionCache.remove(channelDefinitionId);
//        }
//
//        CommandContextUtil.getChannelDefinitionEntityManager(commandContext).update(channelDefinition);
//
//        return null;
//    }
//
//}
