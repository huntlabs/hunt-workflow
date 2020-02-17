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

import flow.common.api.history.HistoricData;
import flow.engine.TaskService;

/**
 * User comments that form discussions around tasks.
 * 
 * @see TaskService#getTaskComments(string)
 * @author Tom Baeyens
 * @author Joram Barrez
 */
interface Comment extends HistoricData {

    /** unique identifier for this comment */
    string getId();

    /** reference to the user that made the comment */
    string getUserId();
    
    void setUserId(string userId);

    /** time and date when the user made the comment */
    @Override
    Date getTime();
    
    void setTime(Date time);

    /** reference to the task on which this comment was made */
    string getTaskId();
    
    void setTaskId(string taskId);

    /** reference to the process instance on which this comment was made */
    string getProcessInstanceId();
    
    void setProcessInstanceId(string processInstanceId);

    /** reference to the type given to the comment */
    string getType();
    
    void setType(string type);

    /**
     * the full comment message the user had related to the task and/or process instance
     * 
     * @see TaskService#getTaskComments(string)
     */
    string getFullMessage();
    
    void setFullMessage(string fullMessage);
}
