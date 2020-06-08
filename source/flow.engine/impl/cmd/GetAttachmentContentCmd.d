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



import java.io.ByteArrayInputStream;
import java.io.InputStream;
import java.io.Serializable;

import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.engine.impl.persistence.entity.AttachmentEntity;
import flow.engine.impl.persistence.entity.ByteArrayEntity;
import flow.engine.impl.util.CommandContextUtil;

/**
 * @author Tom Baeyens
 */
class GetAttachmentContentCmd implements Command!InputStream, Serializable {

    private static final long serialVersionUID = 1L;
    protected string attachmentId;

    public GetAttachmentContentCmd(string attachmentId) {
        this.attachmentId = attachmentId;
    }

    override
    public InputStream execute(CommandContext commandContext) {
        AttachmentEntity attachment = CommandContextUtil.getAttachmentEntityManager().findById(attachmentId);

        string contentId = attachment.getContentId();
        if (contentId is null) {
            return null;
        }

        ByteArrayEntity byteArray = CommandContextUtil.getByteArrayEntityManager().findById(contentId);
        byte[] bytes = byteArray.getBytes();

        return new ByteArrayInputStream(bytes);
    }

}
