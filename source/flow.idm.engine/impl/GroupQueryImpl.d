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

module flow.idm.engine.impl.GroupQueryImpl;

import hunt.collection.List;

import flow.common.api.FlowableIllegalArgumentException;
import flow.common.api.query.QueryCacheValues;
import flow.common.interceptor.CommandContext;
import flow.common.interceptor.CommandExecutor;
import flow.common.query.AbstractQuery;
import flow.idm.api.Group;
import flow.idm.api.GroupQuery;
import flow.idm.api.GroupQueryProperty;
import flow.idm.engine.impl.util.CommandContextUtil;

/**
 * @author Joram Barrez
 */
class GroupQueryImpl : AbstractQuery!(GroupQuery, Group) , GroupQuery, QueryCacheValues {

    protected string id;
    protected List!string ids;
    protected string name;
    protected string nameLike;
    protected string nameLikeIgnoreCase;
    protected string type;
    protected string userId;
    protected List!string userIds;

    this() {
    }

    this(CommandContext commandContext) {
        super(commandContext);
    }

    this(CommandExecutor commandExecutor) {
        super(commandExecutor);
    }


    public GroupQuery groupId(string id) {
        if (id is null) {
            throw new FlowableIllegalArgumentException("Provided id is null");
        }
        this.id = id;
        return this;
    }


    public GroupQuery groupIds(List!string ids) {
        if (ids is null) {
            throw new FlowableIllegalArgumentException("Provided id list is null");
        }
        this.ids = ids;
        return this;
    }


    public GroupQuery groupName(string name) {
        if (name is null) {
            throw new FlowableIllegalArgumentException("Provided name is null");
        }
        this.name = name;
        return this;
    }


    public GroupQuery groupNameLike(string nameLike) {
        if (nameLike is null) {
            throw new FlowableIllegalArgumentException("Provided name is null");
        }
        this.nameLike = nameLike;
        return this;
    }


    public GroupQuery groupNameLikeIgnoreCase(string nameLikeIgnoreCase) {
        if (nameLikeIgnoreCase is null) {
            throw new FlowableIllegalArgumentException("Provided name is null");
        }
        this.nameLikeIgnoreCase = nameLikeIgnoreCase.toLowerCase();
        return this;
    }


    public GroupQuery groupType(string type) {
        if (type is null) {
            throw new FlowableIllegalArgumentException("Provided type is null");
        }
        this.type = type;
        return this;
    }


    public GroupQuery groupMember(string userId) {
        if (userId is null) {
            throw new FlowableIllegalArgumentException("Provided userId is null");
        }
        this.userId = userId;
        return this;
    }


    public GroupQuery groupMembers(List!string userIds) {
        if (userIds is null) {
            throw new FlowableIllegalArgumentException("Provided userIds is null");
        }
        this.userIds = userIds;
        return this;
    }

    // sorting ////////////////////////////////////////////////////////


    public GroupQuery orderByGroupId() {
        return orderBy(GroupQueryProperty.GROUP_ID);
    }


    public GroupQuery orderByGroupName() {
        return orderBy(GroupQueryProperty.NAME);
    }


    public GroupQuery orderByGroupType() {
        return orderBy(GroupQueryProperty.TYPE);
    }

    // results ////////////////////////////////////////////////////////


    public long executeCount(CommandContext commandContext) {
        return CommandContextUtil.getGroupEntityManager(commandContext).findGroupCountByQueryCriteria(this);
    }


    public List!Group executeList(CommandContext commandContext) {
        return CommandContextUtil.getGroupEntityManager(commandContext).findGroupByQueryCriteria(this);
    }

    // getters ////////////////////////////////////////////////////////


    public string getId() {
        return id;
    }

    public List!string getIds() {
        return ids;
    }

    public string getName() {
        return name;
    }

    public string getNameLike() {
        return nameLike;
    }

    public string getNameLikeIgnoreCase() {
        return nameLikeIgnoreCase;
    }

    public string getType() {
        return type;
    }

    public string getUserId() {
        return userId;
    }

    public List!string getUserIds() {
        return userIds;
    }

}
