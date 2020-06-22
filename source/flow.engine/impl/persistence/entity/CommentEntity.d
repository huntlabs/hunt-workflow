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

module flow.engine.impl.persistence.entity.CommentEntity;

import flow.common.persistence.entity.Entity;
import flow.engine.task.Comment;
import flow.engine.task.Event;

/**
 * @author Tom Baeyens
 * @author Joram Barrez
 */
interface CommentEntity : Comment, Event, Entity {

    static string TYPE_EVENT = "event";
    static string TYPE_COMMENT = "comment";

    byte[] getFullMessageBytes();

    void setFullMessageBytes(byte[] fullMessageBytes);

    void setMessage(string[] messageParts);

    void setMessage(string message);

    void setAction(string action);

}
