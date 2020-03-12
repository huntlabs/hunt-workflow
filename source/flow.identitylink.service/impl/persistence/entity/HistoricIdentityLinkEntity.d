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
module flow.identitylink.service.impl.persistence.entity.HistoricIdentityLinkEntity;

import hunt.time.LocalDateTime;

import flow.common.persistence.entity.Entity;
import flow.identitylink.api.history.HistoricIdentityLink;

alias Date = LocalDateTime;
/**
 * @author Joram Barrez
 */
interface HistoricIdentityLinkEntity : HistoricIdentityLink, Entity {

    bool isUser();

    bool isGroup();

    void setType(string type);

    void setUserId(string userId);

    void setGroupId(string groupId);

    void setTaskId(string taskId);

    void setCreateTime(Date createTime);

    void setProcessInstanceId(string processInstanceId);

    void setScopeId(string scopeId);

    void setSubScopeId(string subScopeId);

    void setScopeType(string scopeType);

    void setScopeDefinitionId(string scopeDefinitionId);

}
