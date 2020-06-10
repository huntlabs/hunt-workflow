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
//module flow.event.registry.cmd.DeployCmd;
//
//import hunt.collection.ArrayList;
//import hunt.collection.HashMap;
//import hunt.collection.List;
//import hunt.collection.Map;
//
//import flow.common.interceptor.Command;
//import flow.common.interceptor.CommandContext;
//import flow.event.registry.api.EventDeployment;
//import flow.event.registry.EventDeploymentQueryImpl;
//import flow.event.registry.EventRegistryEngineConfiguration;
//import flow.event.registry.persistence.entity.EventDeploymentEntity;
//import flow.event.registry.persistence.entity.EventResourceEntity;
//import flow.event.registry.repository.EventDeploymentBuilderImpl;
//import flow.event.registry.util.CommandContextUtil;
//
///**
// * @author Tijs Rademakers
// * @author Joram Barrez
// */
//class DeployCmd(T) : Command!EventDeployment {
//
//    protected EventDeploymentBuilderImpl deploymentBuilder;
//
//    this(EventDeploymentBuilderImpl deploymentBuilder) {
//        this.deploymentBuilder = deploymentBuilder;
//    }
//
//    public EventDeployment execute(CommandContext commandContext) {
//
//        EventDeploymentEntity deployment = deploymentBuilder.getDeployment();
//
//        deployment.setDeploymentTime(CommandContextUtil.getEventRegistryConfiguration().getClock().getCurrentTime());
//
//        if (deploymentBuilder.isDuplicateFilterEnabled()) {
//
//            List<EventDeployment> existingDeployments = new ArrayList<>();
//            if (deployment.getTenantId() is null || EventRegistryEngineConfiguration.NO_TENANT_ID.equals(deployment.getTenantId())) {
//                List<EventDeployment> deploymentEntities = new EventDeploymentQueryImpl(CommandContextUtil.getEventRegistryConfiguration().getCommandExecutor()).deploymentName(deployment.getName()).listPage(0, 1);
//                if (!deploymentEntities.isEmpty()) {
//                    existingDeployments.add(deploymentEntities.get(0));
//                }
//            } else {
//                List<EventDeployment> deploymentList = CommandContextUtil.getEventRegistryConfiguration().getEventRepositoryService().createDeploymentQuery().deploymentName(deployment.getName())
//                        .deploymentTenantId(deployment.getTenantId()).orderByDeploymentId().desc().list();
//
//                if (!deploymentList.isEmpty()) {
//                    existingDeployments.addAll(deploymentList);
//                }
//            }
//
//            EventDeploymentEntity existingDeployment = null;
//            if (!existingDeployments.isEmpty()) {
//                existingDeployment = (EventDeploymentEntity) existingDeployments.get(0);
//
//                Map<String, EventResourceEntity> resourceMap = new HashMap<>();
//                List<EventResourceEntity> resourceList = CommandContextUtil.getResourceEntityManager().findResourcesByDeploymentId(existingDeployment.getId());
//                for (EventResourceEntity resourceEntity : resourceList) {
//                    resourceMap.put(resourceEntity.getName(), resourceEntity);
//                }
//                existingDeployment.setResources(resourceMap);
//            }
//
//            if ((existingDeployment !is null) && !deploymentsDiffer(deployment, existingDeployment)) {
//                return existingDeployment;
//            }
//        }
//
//        deployment.setNew(true);
//
//        // Save the data
//        CommandContextUtil.getDeploymentEntityManager(commandContext).insert(deployment);
//
//        // Actually deploy
//        CommandContextUtil.getEventRegistryConfiguration().getDeploymentManager().deploy(deployment);
//
//        return deployment;
//    }
//
//    protected boolean deploymentsDiffer(EventDeploymentEntity deployment, EventDeploymentEntity saved) {
//
//        if (deployment.getResources() is null || saved.getResources() is null) {
//            return true;
//        }
//
//        Map<String, EventResourceEntity> resources = deployment.getResources();
//        Map<String, EventResourceEntity> savedResources = saved.getResources();
//
//        for (String resourceName : resources.keySet()) {
//            EventResourceEntity savedResource = savedResources.get(resourceName);
//
//            if (savedResource is null) {
//                return true;
//            }
//
//            EventResourceEntity resource = resources.get(resourceName);
//
//            byte[] bytes = resource.getBytes();
//            byte[] savedBytes = savedResource.getBytes();
//            if (!Arrays.equals(bytes, savedBytes)) {
//                return true;
//            }
//        }
//        return false;
//    }
//}
