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
//module flow.engine.impl.cmd.ValidateBpmnModelCmd;
//
//import hunt.collection.List;
//
//import flow.bpmn.model.BpmnModel;
//import flow.common.api.FlowableException;
//import flow.common.interceptor.Command;
//import flow.common.interceptor.CommandContext;
//import flow.engine.impl.util.CommandContextUtil;
//import flow.process.validation.ProcessValidator;
//import org.flowable.validation.ValidationError;
//
///**
// * @author Joram Barrez
// */
//class ValidateBpmnModelCmd implements Command<List!ValidationError> {
//
//    protected BpmnModel bpmnModel;
//
//    public ValidateBpmnModelCmd(BpmnModel bpmnModel) {
//        this.bpmnModel = bpmnModel;
//    }
//
//    override
//    public List!ValidationError execute(CommandContext commandContext) {
//        ProcessValidator processValidator = CommandContextUtil.getProcessEngineConfiguration(commandContext).getProcessValidator();
//        if (processValidator is null) {
//            throw new FlowableException("No process validator defined");
//        }
//
//        return processValidator.validate(bpmnModel);
//    }
//
//}
