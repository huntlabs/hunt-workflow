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
module flow.engine.impl.persistence.entity.data.CommentDataManager;

import hunt.collection.List;

import flow.common.persistence.entity.data.DataManager;
import flow.engine.impl.persistence.entity.CommentEntity;
import flow.engine.task.Comment;
import flow.engine.task.Event;

/**
 * @author Joram Barrez
 */
interface CommentDataManager : DataManager!CommentEntity {

    List!Comment findCommentsByTaskId(string taskId);

    List!Comment findCommentsByTaskIdAndType(string taskId, string type);

    List!Comment findCommentsByType(string type);

    List!Event findEventsByTaskId(string taskId);

    List!Event findEventsByProcessInstanceId(string processInstanceId);

    void deleteCommentsByTaskId(string taskId);

    void deleteCommentsByProcessInstanceId(string processInstanceId);

    List!Comment findCommentsByProcessInstanceId(string processInstanceId);

    List!Comment findCommentsByProcessInstanceId(string processInstanceId, string type);

    Comment findComment(string commentId);

    Event findEvent(string commentId);

}
