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
//
//import org.apache.commons.lang3.StringUtils;
//import flow.engine.deleg.DelegateExecution;
//import flow.engine.impl.bpmn.behavior.WebServiceActivityBehavior;
//import flow.engine.impl.bpmn.data.AbstractDataAssociation;
//import flow.engine.impl.bpmn.data.FieldBaseStructureInstance;
//
///**
// * An implicit data input association between a source and a target. source is a variable in the current execution context and target is a property in the message
// *
// * @author Esteban Robles Luna
// */
//class MessageImplicitDataInputAssociation : AbstractDataAssociation {
//
//    private static final long serialVersionUID = 1L;
//
//    public MessageImplicitDataInputAssociation(string source, string target) {
//        super(source, target);
//    }
//
//    override
//    public void evaluate(DelegateExecution execution) {
//        if (StringUtils.isNotEmpty(this.source)) {
//            Object value = execution.getVariable(this.source);
//            MessageInstance message = (MessageInstance) execution.getTransientVariable(WebServiceActivityBehavior.CURRENT_MESSAGE);
//            if (message.getStructureInstance() instanceof FieldBaseStructureInstance) {
//                FieldBaseStructureInstance structure = (FieldBaseStructureInstance) message.getStructureInstance();
//                structure.setFieldValue(this.target, value);
//            }
//        }
//    }
//}
