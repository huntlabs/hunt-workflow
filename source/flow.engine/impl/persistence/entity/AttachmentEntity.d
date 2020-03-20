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

module flow.engine.impl.persistence.entity.AttachmentEntity;

import hunt.time.LocalDateTime;

import flow.common.db.HasRevision;
import flow.common.persistence.entity.Entity;
import flow.engine.task.Attachment;
import flow.engine.impl.persistence.entity.ByteArrayEntity;

/**
 * @author Joram Barrez
 */
interface AttachmentEntity : Attachment, Entity, HasRevision {

    void setType(string type);

    void setTaskId(string taskId);

    void setProcessInstanceId(string processInstanceId);

    void setUrl(string url);

    void setContentId(string contentId);

    ByteArrayEntity getContent();

    void setContent(ByteArrayEntity content);

    void setUserId(string userId);


    string getUserId();


    Date getTime();


    void setTime(Date time);

}
