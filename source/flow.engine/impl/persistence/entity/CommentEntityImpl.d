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
import hunt.collection.ArrayList;
import hunt.time.LocalDateTime;
import hunt.collection.List;
import java.util.regex.Pattern;

/**
 * @author Tom Baeyens
 */
class CommentEntityImpl extends AbstractBpmnEngineNoRevisionEntity implements CommentEntity, Serializable {

    private static final long serialVersionUID = 1L;

    // If comments would be removable, revision needs to be added!

    protected string type;
    protected string userId;
    protected Date time;
    protected string taskId;
    protected string processInstanceId;
    protected string action;
    protected string message;
    protected string fullMessage;

    public CommentEntityImpl() {

    }

    @Override
    public Object getPersistentState() {
        return CommentEntityImpl.class;
    }

    @Override
    public byte[] getFullMessageBytes() {
        return (fullMessage !is null ? fullMessage.getBytes() : null);
    }

    @Override
    public void setFullMessageBytes(byte[] fullMessageBytes) {
        fullMessage = (fullMessageBytes !is null ? new string(fullMessageBytes) : null);
    }

    public static final string MESSAGE_PARTS_MARKER = "_|_";
    public static final Pattern MESSAGE_PARTS_MARKER_REGEX = Pattern.compile("_\\|_");

    @Override
    public void setMessage(string[] messageParts) {
        StringBuilder stringBuilder = new StringBuilder();
        for (string part : messageParts) {
            if (part !is null) {
                stringBuilder.append(part.replace(MESSAGE_PARTS_MARKER, " | "));
                stringBuilder.append(MESSAGE_PARTS_MARKER);
            } else {
                stringBuilder.append("null");
                stringBuilder.append(MESSAGE_PARTS_MARKER);
            }
        }
        for (int i = 0; i < MESSAGE_PARTS_MARKER.length(); i++) {
            stringBuilder.deleteCharAt(stringBuilder.length() - 1);
        }
        message = stringBuilder.toString();
    }

    @Override
    public List!string getMessageParts() {
        if (message is null) {
            return null;
        }
        List!string messageParts = new ArrayList<>();

        string[] parts = MESSAGE_PARTS_MARKER_REGEX.split(message);
        for (string part : parts) {
            if ("null".equals(part)) {
                messageParts.add(null);
            } else {
                messageParts.add(part);
            }
        }
        return messageParts;
    }

    // getters and setters
    // //////////////////////////////////////////////////////

    @Override
    public string getUserId() {
        return userId;
    }

    @Override
    public void setUserId(string userId) {
        this.userId = userId;
    }

    @Override
    public string getTaskId() {
        return taskId;
    }

    @Override
    public void setTaskId(string taskId) {
        this.taskId = taskId;
    }

    @Override
    public string getMessage() {
        return message;
    }

    @Override
    public void setMessage(string message) {
        this.message = message;
    }

    @Override
    public Date getTime() {
        return time;
    }

    @Override
    public void setTime(Date time) {
        this.time = time;
    }

    @Override
    public string getProcessInstanceId() {
        return processInstanceId;
    }

    @Override
    public void setProcessInstanceId(string processInstanceId) {
        this.processInstanceId = processInstanceId;
    }

    @Override
    public string getType() {
        return type;
    }

    @Override
    public void setType(string type) {
        this.type = type;
    }

    @Override
    public string getFullMessage() {
        return fullMessage;
    }

    @Override
    public void setFullMessage(string fullMessage) {
        this.fullMessage = fullMessage;
    }

    @Override
    public string getAction() {
        return action;
    }

    @Override
    public void setAction(string action) {
        this.action = action;
    }
}
