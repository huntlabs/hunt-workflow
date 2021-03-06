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
//
//import java.io.Serializable;
//
//import flow.common.interceptor.Command;
//import flow.common.interceptor.CommandContext;
//import flow.event.registry.persistence.entity.EventDefinitionEntity;
//import flow.event.registry.util.CommandContextUtil;
//
///**
// * @author Tijs Rademakers
// */
//class GetEventDefinitionCmd implements Command<EventDefinitionEntity>, Serializable {
//
//    private static final long serialVersionUID = 1L;
//    protected String eventDefinitionId;
//
//    public GetEventDefinitionCmd(String eventDefinitionId) {
//        this.eventDefinitionId = eventDefinitionId;
//    }
//
//    @Override
//    public EventDefinitionEntity execute(CommandContext commandContext) {
//        return CommandContextUtil.getEventRegistryConfiguration().getDeploymentManager()
//                .findDeployedEventDefinitionById(eventDefinitionId);
//    }
//}
