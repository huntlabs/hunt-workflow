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



import java.util.Date;

import flow.engine.TaskService;

/**
 * Any type of content that is be associated with a task or with a process instance.
 * 
 * @author Tom Baeyens
 */
interface Attachment {

    /** unique id for this attachment */
    string getId();

    /** free user defined short (max 255 chars) name for this attachment */
    string getName();

    /** free user defined short (max 255 chars) name for this attachment */
    void setName(string name);

    /**
     * long (max 255 chars) explanation what this attachment is about in context of the task and/or process instance it's linked to.
     */
    string getDescription();

    /**
     * long (max 255 chars) explanation what this attachment is about in context of the task and/or process instance it's linked to.
     */
    void setDescription(string description);

    /**
     * indication of the type of content that this attachment refers to. Can be mime type or any other indication.
     */
    string getType();

    /** reference to the task to which this attachment is associated. */
    string getTaskId();

    /**
     * reference to the process instance to which this attachment is associated.
     */
    string getProcessInstanceId();

    /**
     * the remote URL in case this is remote content. If the attachment content was {@link TaskService#createAttachment(string, string, string, string, string, java.io.InputStream) uploaded with an
     * input stream}, then this method returns null and the content can be fetched with {@link TaskService#getAttachmentContent(string)}.
     */
    string getUrl();

    /** reference to the user who created this attachment. */
    string getUserId();

    /** timestamp when this attachment was created */
    Date getTime();

    /** timestamp when this attachment was created */
    void setTime(Date time);

    /** the id of the byte array entity storing the content */
    string getContentId();

}
