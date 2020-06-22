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
module flow.engine.impl.bpmn.behavior.BusinessRuleTaskActivityBehavior;

import hunt.collection.ArrayList;
import hunt.collection;
import hunt.collection.HashSet;
import hunt.collection.Set;

import flow.common.api.deleg.Expression;
import flow.engine.deleg.BusinessRuleTaskDelegate;
import flow.engine.deleg.DelegateExecution;
//import flow.engine.impl.rules.RulesAgendaFilter;
import flow.engine.impl.rules.RulesHelper;
import flow.engine.impl.util.ProcessDefinitionUtil;
import flow.engine.repository.ProcessDefinition;
//import org.kie.api.KieBase;
//import org.kie.api.runtime.KieSession;
import flow.engine.impl.bpmn.behavior.TaskActivityBehavior;
import hunt.Exceptions;

/**
 * Activity implementation of the BPMN 2.0 business rule task.
 *
 * @author Tijs Rademakers
 * @author Joram Barrez
 */
class BusinessRuleTaskActivityBehavior : TaskActivityBehavior , BusinessRuleTaskDelegate {

    protected Set!Expression variablesInputExpressions ;//= new HashSet<>();
    protected Set!Expression rulesExpressions ;// = new HashSet<>();
    protected bool exclude;
    protected string resultVariable;

    this() {
        variablesInputExpressions = new HashSet!Expression;
        rulesExpressions = new HashSet!Expression;
    }

    override
    public void execute(DelegateExecution execution) {
        implementationMissing(false);
        //ProcessDefinition processDefinition = ProcessDefinitionUtil.getProcessDefinition(execution.getProcessDefinitionId());
        //string deploymentId = processDefinition.getDeploymentId();
        //
        //KieBase knowledgeBase = RulesHelper.findKnowledgeBaseByDeploymentId(deploymentId);
        //KieSession ksession = knowledgeBase.newKieSession();
        //
        //if (variablesInputExpressions !is null) {
        //    Iterator!Expression itVariable = variablesInputExpressions.iterator();
        //    while (itVariable.hasNext()) {
        //        Expression variable = itVariable.next();
        //        ksession.insert(variable.getValue(execution));
        //    }
        //}
        //
        //if (!rulesExpressions.isEmpty()) {
        //    RulesAgendaFilter filter = new RulesAgendaFilter();
        //    Iterator!Expression itRuleNames = rulesExpressions.iterator();
        //    while (itRuleNames.hasNext()) {
        //        Expression ruleName = itRuleNames.next();
        //        filter.addSuffic(ruleName.getValue(execution).toString());
        //    }
        //    filter.setAccept(!exclude);
        //    ksession.fireAllRules(filter);
        //
        //} else {
        //    ksession.fireAllRules();
        //}
        //
        //Collection<? : Object> ruleOutputObjects = ksession.getObjects();
        //if (ruleOutputObjects !is null && !ruleOutputObjects.isEmpty()) {
        //    Collection!Object outputVariables = new ArrayList<>(ruleOutputObjects);
        //    execution.setVariable(resultVariable, outputVariables);
        //}
        //ksession.dispose();
        //leave(execution);
    }

    public void addRuleVariableInputIdExpression(Expression inputId) {
        this.variablesInputExpressions.add(inputId);
    }

    public void addRuleIdExpression(Expression inputId) {
        this.rulesExpressions.add(inputId);
    }

    public void setExclude(bool exclude) {
        this.exclude = exclude;
    }

    public void setResultVariable(string resultVariableName) {
        this.resultVariable = resultVariableName;
    }

}
