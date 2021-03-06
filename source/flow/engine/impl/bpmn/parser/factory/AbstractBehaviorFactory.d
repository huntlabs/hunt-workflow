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
module flow.engine.impl.bpmn.parser.factory.AbstractBehaviorFactory;

import hunt.collection.ArrayList;
import hunt.collection.List;

import flow.bpmn.model.FieldExtension;
import flow.common.api.deleg.Expression;
import flow.common.el.ExpressionManager;
import flow.engine.impl.bpmn.parser.FieldDeclaration;
import flow.engine.impl.el.FixedValue;
import hunt.String;
/**
 * @author Joram Barrez
 */
abstract class AbstractBehaviorFactory {

    protected ExpressionManager expressionManager;

    public List!FieldDeclaration createFieldDeclarations(List!FieldExtension fieldList) {
        List!FieldDeclaration fieldDeclarations = new ArrayList!FieldDeclaration();

        foreach (FieldExtension fieldExtension ; fieldList) {
            FieldDeclaration fieldDeclaration = null;
            if (fieldExtension.getExpression() !is null && fieldExtension.getExpression().length != 0) {
                fieldDeclaration = new FieldDeclaration(fieldExtension.getFieldName(), typeid(Expression).toString, cast(Object)(expressionManager.createExpression(fieldExtension.getExpression())));
            } else {
                fieldDeclaration = new FieldDeclaration(fieldExtension.getFieldName(), typeid(Expression).toString, new FixedValue(new String(fieldExtension.getStringValue())));
            }

            fieldDeclarations.add(fieldDeclaration);
        }
        return fieldDeclarations;
    }

    public ExpressionManager getExpressionManager() {
        return expressionManager;
    }

    public void setExpressionManager(ExpressionManager expressionManager) {
        this.expressionManager = expressionManager;
    }

}
