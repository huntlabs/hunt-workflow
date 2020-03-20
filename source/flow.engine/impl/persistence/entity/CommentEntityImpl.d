///* Licensed under the Apache License, Version 2.0 (the "License");
// * you may not use this file except in compliance with the License.
// * You may obtain a copy of the License at
// *
// *      http://www.apache.org/licenses/LICENSE-2.0
// *
// * Unless required by applicable law or agreed to in writing, software
// * distributed under the License is distributed on an "AS IS" BASIS,
// * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// * See the License for the specific language governing permissions and
// * limitations under the License.
// */
//
//module flow.engine.impl.persistence.entity.CommentEntityImpl;
//
//import hunt.collection.ArrayList;
//import hunt.time.LocalDateTime;
//import hunt.collection.List;
////import java.util.regex.Pattern;
//import flow.engine.impl.persistence.entity.AbstractBpmnEngineNoRevisionEntity;
//import flow.engine.impl.persistence.entity.CommentEntity;
//
///**
// * @author Tom Baeyens
// */
//class CommentEntityImpl : AbstractBpmnEngineNoRevisionEntity , CommentEntity {
//
//    private static final long serialVersionUID = 1L;
//
//    // If comments would be removable, revision needs to be added!
//
//    protected string type;
//    protected string userId;
//    protected Date time;
//    protected string taskId;
//    protected string processInstanceId;
//    protected string action;
//    protected string message;
//    protected string fullMessage;
//
//    this() {
//
//    }
//
//
//    public Object getPersistentState() {
//        return CommentEntityImpl.class;
//    }
//
//
//    public byte[] getFullMessageBytes() {
//        return (fullMessage !is null ? fullMessage.getBytes() : null);
//    }
//
//
//    public void setFullMessageBytes(byte[] fullMessageBytes) {
//        fullMessage = (fullMessageBytes !is null ? new string(fullMessageBytes) : null);
//    }
//
//    public static final string MESSAGE_PARTS_MARKER = "_|_";
//    public static final Pattern MESSAGE_PARTS_MARKER_REGEX = Pattern.compile("_\\|_");
//
//
//    public void setMessage(string[] messageParts) {
//        StringBuilder stringBuilder = new StringBuilder();
//        for (string part : messageParts) {
//            if (part !is null) {
//                stringBuilder.append(part.replace(MESSAGE_PARTS_MARKER, " | "));
//                stringBuilder.append(MESSAGE_PARTS_MARKER);
//            } else {
//                stringBuilder.append("null");
//                stringBuilder.append(MESSAGE_PARTS_MARKER);
//            }
//        }
//        for (int i = 0; i < MESSAGE_PARTS_MARKER.length(); i++) {
//            stringBuilder.deleteCharAt(stringBuilder.length() - 1);
//        }
//        message = stringBuilder.toString();
//    }
//
//
//    public List!string getMessageParts() {
//        if (message is null) {
//            return null;
//        }
//        List!string messageParts = new ArrayList<>();
//
//        string[] parts = MESSAGE_PARTS_MARKER_REGEX.split(message);
//        for (string part : parts) {
//            if ("null".equals(part)) {
//                messageParts.add(null);
//            } else {
//                messageParts.add(part);
//            }
//        }
//        return messageParts;
//    }
//
//    // getters and setters
//    // //////////////////////////////////////////////////////
//
//
//    public string getUserId() {
//        return userId;
//    }
//
//
//    public void setUserId(string userId) {
//        this.userId = userId;
//    }
//
//
//    public string getTaskId() {
//        return taskId;
//    }
//
//
//    public void setTaskId(string taskId) {
//        this.taskId = taskId;
//    }
//
//
//    public string getMessage() {
//        return message;
//    }
//
//
//    public void setMessage(string message) {
//        this.message = message;
//    }
//
//
//    public Date getTime() {
//        return time;
//    }
//
//
//    public void setTime(Date time) {
//        this.time = time;
//    }
//
//
//    public string getProcessInstanceId() {
//        return processInstanceId;
//    }
//
//
//    public void setProcessInstanceId(string processInstanceId) {
//        this.processInstanceId = processInstanceId;
//    }
//
//
//    public string getType() {
//        return type;
//    }
//
//
//    public void setType(string type) {
//        this.type = type;
//    }
//
//
//    public string getFullMessage() {
//        return fullMessage;
//    }
//
//
//    public void setFullMessage(string fullMessage) {
//        this.fullMessage = fullMessage;
//    }
//
//
//    public string getAction() {
//        return action;
//    }
//
//
//    public void setAction(string action) {
//        this.action = action;
//    }
//}
