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

import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.task.Attachment;

/**
 * @author Tom Baeyens
 */
class GetTaskAttachmentsCmd implements Command<List<? extends Attachment>>, Serializable {

    private static final long serialVersionUID = 1L;
    protected string taskId;

    public GetTaskAttachmentsCmd(string taskId) {
        this.taskId = taskId;
    }

    @Override
    public List<? extends Attachment> execute(CommandContext commandContext) {
        return CommandContextUtil.getAttachmentEntityManager().findAttachmentsByTaskId(taskId);
    }
}