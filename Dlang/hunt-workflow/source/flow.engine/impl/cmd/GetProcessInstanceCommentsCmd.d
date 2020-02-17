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
import java.util.List;

import org.apache.commons.lang3.StringUtils;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.task.Comment;

/**
 * @author Tom Baeyens
 */
class GetProcessInstanceCommentsCmd implements Command<List<Comment>>, Serializable {

    private static final long serialVersionUID = 1L;
    protected string processInstanceId;
    protected string type;

    public GetProcessInstanceCommentsCmd(string processInstanceId) {
        this.processInstanceId = processInstanceId;
    }

    public GetProcessInstanceCommentsCmd(string processInstanceId, string type) {
        this.processInstanceId = processInstanceId;
        this.type = type;
    }

    @SuppressWarnings("unchecked")
    @Override
    public List<Comment> execute(CommandContext commandContext) {
        if (StringUtils.isNotBlank(type)) {
            List<Comment> commentsByProcessInstanceId = CommandContextUtil.getCommentEntityManager(commandContext).findCommentsByProcessInstanceId(processInstanceId, type);
            return commentsByProcessInstanceId;
        } else {
            return CommandContextUtil.getCommentEntityManager(commandContext).findCommentsByProcessInstanceId(processInstanceId);
        }
    }
}
