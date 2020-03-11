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

module flow.idm.engine.impl.PrivilegeQueryImpl;

import hunt.collection.List;

import flow.common.api.query.QueryCacheValues;
import flow.common.interceptor.CommandContext;
import flow.common.interceptor.CommandExecutor;
import flow.common.query.AbstractQuery;
import flow.idm.api.Privilege;
import flow.idm.api.PrivilegeQuery;
import flow.idm.engine.impl.util.CommandContextUtil;

/**
 * @author Joram Barrez
 */
class PrivilegeQueryImpl : AbstractQuery!(PrivilegeQuery, Privilege) , PrivilegeQuery, QueryCacheValues {


    protected string id;
    protected string name;
    protected string userId;
    protected string groupId;
    protected List!string groupIds;

    this() {
    }

    this(CommandContext commandContext) {
        super(commandContext);
    }

    this(CommandExecutor commandExecutor) {
        super(commandExecutor);
    }


    public PrivilegeQuery privilegeId(string id) {
        this.id = id;
        return this;
    }


    public PrivilegeQuery privilegeName(string name) {
        this.name = name;
        return this;
    }


    public PrivilegeQuery userId(string userId) {
        this.userId = userId;
        return this;
    }


    public PrivilegeQuery groupId(string groupId) {
        this.groupId = groupId;
        return this;
    }


    public PrivilegeQuery groupIds(List!string groupIds) {
        this.groupIds = groupIds;
        return this;
    }


    public string getId() {
        return id;
    }

    public void setId(string id) {
        this.id = id;
    }

    public string getName() {
        return name;
    }

    public void setName(string name) {
        this.name = name;
    }

    public string getUserId() {
        return userId;
    }

    public void setUserId(string userId) {
        this.userId = userId;
    }

    public string getGroupId() {
        return groupId;
    }

    public void setGroupId(string groupId) {
        this.groupId = groupId;
    }

    public List!string getGroupIds() {
        return groupIds;
    }

    public void setGroupIds(List!string groupIds) {
        this.groupIds = groupIds;
    }


    public long executeCount(CommandContext commandContext) {
        return CommandContextUtil.getPrivilegeEntityManager(commandContext).findPrivilegeCountByQueryCriteria(this);
    }


    public List!Privilege executeList(CommandContext commandContext) {
        return CommandContextUtil.getPrivilegeEntityManager(commandContext).findPrivilegeByQueryCriteria(this);
    }

}
