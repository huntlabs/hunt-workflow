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



import java.io.Serializable;
import java.util.Date;
import java.util.List;

/**
 * Exposes twitter-like feeds for tasks and process instances.
 *
 * @author Tom Baeyens
 */
interface Event extends Serializable {

    /**
     * A user identity link was added with following message parts: [0] userId [1] identity link type (aka role)
     */
    string ACTION_ADD_USER_LINK = "AddUserLink";

    /**
     * A user identity link was added with following message parts: [0] userId [1] identity link type (aka role)
     */
    string ACTION_DELETE_USER_LINK = "DeleteUserLink";

    /**
     * A group identity link was added with following message parts: [0] groupId [1] identity link type (aka role)
     */
    string ACTION_ADD_GROUP_LINK = "AddGroupLink";

    /**
     * A group identity link was added with following message parts: [0] groupId [1] identity link type (aka role)
     */
    string ACTION_DELETE_GROUP_LINK = "DeleteGroupLink";

    /**
     * An user comment was added with the short version of the comment as message.
     */
    string ACTION_ADD_COMMENT = "AddComment";

    /** An attachment was added with the attachment name as message. */
    string ACTION_ADD_ATTACHMENT = "AddAttachment";

    /** An attachment was deleted with the attachment name as message. */
    string ACTION_DELETE_ATTACHMENT = "DeleteAttachment";

    /** Unique identifier for this event */
    string getId();

    /**
     * Indicates the type of of action and also indicates the meaning of the parts as exposed in {@link #getMessageParts()}
     */
    string getAction();

    /**
     * The meaning of the message parts is defined by the action as you can find in {@link #getAction()}
     */
    List<string> getMessageParts();

    /**
     * The message that can be used in case this action only has a single message part.
     */
    string getMessage();

    /** reference to the user that made the comment */
    string getUserId();

    /** time and date when the user made the comment */
    Date getTime();

    /** reference to the task on which this comment was made */
    string getTaskId();

    /** reference to the process instance on which this comment was made */
    string getProcessInstanceId();

}
