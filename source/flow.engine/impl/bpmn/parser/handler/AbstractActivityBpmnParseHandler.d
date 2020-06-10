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
module flow.engine.impl.bpmn.parser.handler.AbstractActivityBpmnParseHandler;

import flow.bpmn.model.Activity;
import flow.bpmn.model.BaseElement;
import flow.bpmn.model.FlowNode;
import flow.bpmn.model.MultiInstanceLoopCharacteristics;
import flow.common.el.ExpressionManager;
import flow.engine.impl.bpmn.behavior.AbstractBpmnActivityBehavior;
import flow.engine.impl.bpmn.behavior.MultiInstanceActivityBehavior;
import flow.engine.impl.bpmn.parser.BpmnParse;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.impl.bpmn.parser.handler.AbstractFlowNodeBpmnParseHandler;
/**
 * @author Joram Barrez
 */
abstract class AbstractActivityBpmnParseHandler(T) : AbstractFlowNodeBpmnParseHandler!T {

    override
    public void parse(BpmnParse bpmnParse, BaseElement element) {
        super.parse(bpmnParse, element);

        if (cast(Activity)element !is null && (cast(Activity) element).getLoopCharacteristics() !is null) {
            createMultiInstanceLoopCharacteristics(bpmnParse, cast(Activity) element);
        }
    }

    protected void createMultiInstanceLoopCharacteristics(BpmnParse bpmnParse, Activity modelActivity) {

        MultiInstanceLoopCharacteristics loopCharacteristics = modelActivity.getLoopCharacteristics();

        // Activity Behavior
        MultiInstanceActivityBehavior miActivityBehavior = createMultiInstanceActivityBehavior(modelActivity, loopCharacteristics, bpmnParse);
        modelActivity.setBehavior(miActivityBehavior);

        ExpressionManager expressionManager = CommandContextUtil.getProcessEngineConfiguration().getExpressionManager();

        // loop cardinality
        if (loopCharacteristics.getLoopCardinality() !is null && loopCharacteristics.getLoopCardinality().length != 0) {
            miActivityBehavior.setLoopCardinalityExpression(expressionManager.createExpression(loopCharacteristics.getLoopCardinality()));
        }

        // completion condition
        if (loopCharacteristics.getCompletionCondition() !is null && loopCharacteristics.getCompletionCondition().length != 0) {
            miActivityBehavior.setCompletionCondition(loopCharacteristics.getCompletionCondition());
        }

        // flowable:collection
        if (loopCharacteristics.getInputDataItem() !is null && loopCharacteristics.getInputDataItem().length != 0) {
            miActivityBehavior.setCollectionExpression(expressionManager.createExpression(loopCharacteristics.getInputDataItem()));
        }

        // flowable:collectionString
        if (loopCharacteristics.getCollectionString() !is null && loopCharacteristics.getCollectionString().length != 0) {
            miActivityBehavior.setCollectionString(loopCharacteristics.getCollectionString());
        }

        // flowable:elementVariable
        if (loopCharacteristics.getElementVariable() !is null && loopCharacteristics.getElementVariable().length != 0) {
            miActivityBehavior.setCollectionElementVariable(loopCharacteristics.getElementVariable());
        }

        // flowable:elementIndexVariable
        if (loopCharacteristics.getElementIndexVariable() !is null && loopCharacteristics.getElementIndexVariable().length != 0) {
            miActivityBehavior.setCollectionElementIndexVariable(loopCharacteristics.getElementIndexVariable());
        }

        // flowable:collectionParser
        if (loopCharacteristics.getHandler() !is null) {
            miActivityBehavior.setHandler(loopCharacteristics.getHandler().clone());
        }
    }

    protected MultiInstanceActivityBehavior createMultiInstanceActivityBehavior(Activity modelActivity, MultiInstanceLoopCharacteristics loopCharacteristics, BpmnParse bpmnParse) {
        MultiInstanceActivityBehavior miActivityBehavior = null;

        AbstractBpmnActivityBehavior modelActivityBehavior = cast(AbstractBpmnActivityBehavior) modelActivity.getBehavior();
        if (loopCharacteristics.isSequential()) {
            miActivityBehavior = bpmnParse.getActivityBehaviorFactory().createSequentialMultiInstanceBehavior(modelActivity, modelActivityBehavior);
        } else {
            miActivityBehavior = bpmnParse.getActivityBehaviorFactory().createParallelMultiInstanceBehavior(modelActivity, modelActivityBehavior);
        }

        return miActivityBehavior;
    }
}
