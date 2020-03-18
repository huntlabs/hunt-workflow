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

module flow.idm.engine.impl.UserQueryImpl;


import hunt.collection.List;

import flow.common.api.FlowableIllegalArgumentException;
import flow.common.api.query.QueryCacheValues;
import flow.common.interceptor.CommandContext;
import flow.common.interceptor.CommandExecutor;
import flow.common.query.AbstractQuery;
import flow.idm.api.User;
import flow.idm.api.UserQuery;
import flow.idm.api.UserQueryProperty;
import flow.idm.engine.impl.util.CommandContextUtil;
import std.string;

/**
 * @author Joram Barrez
 */
class UserQueryImpl : AbstractQuery!(UserQuery, User) , UserQuery, QueryCacheValues {

    protected string id;
    protected List!string ids;
    protected string idIgnoreCase;
    protected string firstName;
    protected string firstNameLike;
    protected string firstNameLikeIgnoreCase;
    protected string lastName;
    protected string lastNameLike;
    protected string lastNameLikeIgnoreCase;
    protected string fullNameLike;
    protected string fullNameLikeIgnoreCase;
    protected string displayName;
    protected string displayNameLike;
    protected string displayNameLikeIgnoreCase;
    protected string email;
    protected string emailLike;
    protected string groupId;
    protected List!string groupIds;
    protected string tenantId;

    this() {
    }

    this(CommandContext commandContext) {
        super(commandContext);
    }

    this(CommandExecutor commandExecutor) {
        super(commandExecutor);
    }


    public UserQuery userId(string id) {
        if (id is null) {
            throw new FlowableIllegalArgumentException("Provided id is null");
        }
        this.id = id;
        return this;
    }


    public UserQuery userIds(List!string ids) {
        if (ids is null) {
            throw new FlowableIllegalArgumentException("Provided ids is null");
        }
        this.ids = ids;
        return this;
    }


    public UserQuery userIdIgnoreCase(string id) {
        if (id is null) {
            throw new FlowableIllegalArgumentException("Provided id is null");
        }
        this.idIgnoreCase = toLower!string(id);
        return this;
    }


    public UserQuery userFirstName(string firstName) {
        if (firstName is null) {
            throw new FlowableIllegalArgumentException("Provided first name is null");
        }
        this.firstName = firstName;
        return this;
    }


    public UserQuery userFirstNameLike(string firstNameLike) {
        if (firstNameLike is null) {
            throw new FlowableIllegalArgumentException("Provided first name is null");
        }
        this.firstNameLike = firstNameLike;
        return this;
    }


    public UserQuery userFirstNameLikeIgnoreCase(string firstNameLikeIgnoreCase) {
        if (firstNameLikeIgnoreCase is null) {
            throw new FlowableIllegalArgumentException("Provided first name is null");
        }
        this.firstNameLikeIgnoreCase = toLower!string(firstNameLikeIgnoreCase);
        return this;
    }


    public UserQuery userLastName(string lastName) {
        if (lastName is null) {
            throw new FlowableIllegalArgumentException("Provided last name is null");
        }
        this.lastName = lastName;
        return this;
    }


    public UserQuery userLastNameLike(string lastNameLike) {
        if (lastNameLike is null) {
            throw new FlowableIllegalArgumentException("Provided last name is null");
        }
        this.lastNameLike = lastNameLike;
        return this;
    }


    public UserQuery userLastNameLikeIgnoreCase(string lastNameLikeIgnoreCase) {
        if (lastNameLikeIgnoreCase is null) {
            throw new FlowableIllegalArgumentException("Provided last name is null");
        }
        this.lastNameLikeIgnoreCase = toLower!string(lastNameLikeIgnoreCase);
        return this;
    }


    public UserQuery userFullNameLike(string fullNameLike) {
        if (fullNameLike is null) {
            throw new FlowableIllegalArgumentException("Provided full name is null");
        }
        this.fullNameLike = fullNameLike;
        return this;
    }


    public UserQuery userFullNameLikeIgnoreCase(string fullNameLikeIgnoreCase) {
        if (fullNameLikeIgnoreCase is null) {
            throw new FlowableIllegalArgumentException("Provided full name is null");
        }
        this.fullNameLikeIgnoreCase = toLower!string(fullNameLikeIgnoreCase);
        return this;
    }


    public UserQuery userDisplayName(string displayName) {
        if (displayName is null) {
            throw new FlowableIllegalArgumentException("Provided display name is null");
        }
        this.displayName = displayName;
        return this;
    }


    public UserQuery userDisplayNameLike(string displayNameLike) {
        if (displayNameLike is null) {
            throw new FlowableIllegalArgumentException("Provided display name is null");
        }
        this.displayNameLike = displayNameLike;
        return this;
    }


    public UserQuery userDisplayNameLikeIgnoreCase(string displayNameLikeIgnoreCase) {
        if (displayNameLikeIgnoreCase is null) {
            throw new FlowableIllegalArgumentException("Provided display name is null");
        }
        this.displayNameLikeIgnoreCase = toLower!string(displayNameLikeIgnoreCase);
        return this;
    }


    public UserQuery userEmail(string email) {
        if (email is null) {
            throw new FlowableIllegalArgumentException("Provided email is null");
        }
        this.email = email;
        return this;
    }


    public UserQuery userEmailLike(string emailLike) {
        if (emailLike is null) {
            throw new FlowableIllegalArgumentException("Provided emailLike is null");
        }
        this.emailLike = emailLike;
        return this;
    }


    public UserQuery memberOfGroup(string groupId) {
        if (groupId is null) {
            throw new FlowableIllegalArgumentException("Provided groupId is null");
        }
        this.groupId = groupId;
        return this;
    }


    public UserQuery memberOfGroups(List!string groupIds) {
        if (groupIds is null) {
            throw new FlowableIllegalArgumentException("Provided groupIds is null");
        }
        this.groupIds = groupIds;
        return this;
    }


    public UserQuery tenantId(string tenantId) {
        if (tenantId is null) {
            throw new FlowableIllegalArgumentException("TenantId is null");
        }
        this.tenantId = tenantId;
        return this;
    }

    // sorting //////////////////////////////////////////////////////////


    public UserQuery orderByUserId() {
        return orderBy(UserQueryProperty.USER_ID);
    }


    public UserQuery orderByUserEmail() {
        return orderBy(UserQueryProperty.EMAIL);
    }


    public UserQuery orderByUserFirstName() {
        return orderBy(UserQueryProperty.FIRST_NAME);
    }


    public UserQuery orderByUserLastName() {
        return orderBy(UserQueryProperty.LAST_NAME);
    }

    // results //////////////////////////////////////////////////////////


    public long executeCount(CommandContext commandContext) {
        return CommandContextUtil.getUserEntityManager(commandContext).findUserCountByQueryCriteria(this);
    }


    public List!User executeList(CommandContext commandContext) {
        return CommandContextUtil.getUserEntityManager(commandContext).findUserByQueryCriteria(this);
    }

    // getters //////////////////////////////////////////////////////////


    public string getId() {
        return id;
    }

    public List!string getIds() {
        return ids;
    }

    public string getIdIgnoreCase() {
        return idIgnoreCase;
    }

    public string getFirstName() {
        return firstName;
    }

    public string getFirstNameLike() {
        return firstNameLike;
    }

    public string getFirstNameLikeIgnoreCase() {
        return firstNameLikeIgnoreCase;
    }

    public string getLastName() {
        return lastName;
    }

    public string getLastNameLike() {
        return lastNameLike;
    }

    public string getLastNameLikeIgnoreCase() {
        return lastNameLikeIgnoreCase;
    }

    public string getEmail() {
        return email;
    }

    public string getEmailLike() {
        return emailLike;
    }

    public string getGroupId() {
        return groupId;
    }

    public List!string getGroupIds() {
        return groupIds;
    }

    public string getFullNameLike() {
        return fullNameLike;
    }

    public string getFullNameLikeIgnoreCase() {
        return fullNameLikeIgnoreCase;
    }

}
