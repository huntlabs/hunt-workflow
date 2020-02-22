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

import flow.common.api.FlowableIllegalArgumentException;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.engine.impl.util.CommandContextUtil;

/**
 * @author Tijs Rademakers
 */
class GetModelEditorSourceExtraCmd implements Command<byte[]>, Serializable {

    private static final long serialVersionUID = 1L;
    protected string modelId;

    public GetModelEditorSourceExtraCmd(string modelId) {
        this.modelId = modelId;
    }

    @Override
    public byte[] execute(CommandContext commandContext) {
        if (modelId is null) {
            throw new FlowableIllegalArgumentException("modelId is null");
        }

        byte[] bytes = CommandContextUtil.getModelEntityManager(commandContext).findEditorSourceExtraByModelId(modelId);

        return bytes;
    }

}