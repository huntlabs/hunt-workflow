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

module flow.variable.service.impl.el.NoExecutionVariableScope;

import hunt.collection;
import hunt.collection.Collections;
import hunt.collection.Map;
import hunt.collection.Set;

import flow.variable.service.api.deleg.VariableScope;
import flow.variable.service.api.persistence.entity.VariableInstance;
import std.concurrency : initOnce;
/**
 * Variable-scope only used to resolve variables when NO execution is active but expression-resolving is needed. This occurs eg. when start-form properties have default's defined. Even though
 * variables are not available yet, expressions should be resolved anyway.
 *
 * @author Frederik Heremans
 * @author Joram Barrez
 */
class NoExecutionVariableScope : VariableScope {

   // private static final NoExecutionVariableScope INSTANCE = new NoExecutionVariableScope();

    /**
     * Since a {@link NoExecutionVariableScope} has no state, it's safe to use the same instance to prevent too many useless instances created.
     */
    //public static NoExecutionVariableScope getSharedInstance() {
    //    return INSTANCE;
    //}

      static NoExecutionVariableScope  getSharedInstance() {
        __gshared NoExecutionVariableScope  inst;
        return initOnce!inst(new NoExecutionVariableScope());
      }

    public Map!(string, Object) getVariables() {
        return Collections.emptyMap!(string, Object);
    }

    public Map!(string, Object) getVariablesLocal() {
        return Collections.emptyMap!(string, Object);
    }

    public Map!(string, Object) getVariables(Collection!string variableNames) {
        return Collections.emptyMap!(string, Object);
    }

    public Map!(string, Object) getVariables(Collection!string variableNames, bool fetchAllVariables) {
        return Collections.emptyMap!(string, Object);
    }

    public Map!(string, Object) getVariablesLocal(Collection!string variableNames) {
        return Collections.emptyMap!(string, Object);
    }

    public Map!(string, Object) getVariablesLocal(Collection!string variableNames, bool fetchAllVariables) {
        return Collections.emptyMap!(string, Object);
    }


    public Object getVariable(string variableName) {
        return null;
    }


    public Object getVariable(string variableName, bool fetchAllVariables) {
        return null;
    }


    public Object getVariableLocal(string variableName) {
        return null;
    }


    public Object getVariableLocal(string variableName, bool fetchAllVariables) {
        return null;
    }


    //public <T> T getVariable(string variableName, Class<T> variableClass) {
    //    return null;
    //}
    //
    //
    //public <T> T getVariableLocal(string variableName, Class<T> variableClass) {
    //    return null;
    //}


    public Map!(string, VariableInstance) getVariableInstances() {
        return null;
    }


    public Map!(string, VariableInstance) getVariableInstances(Collection!string variableNames) {
        return null;
    }


    public Map!(string, VariableInstance) getVariableInstances(Collection!string variableNames, bool fetchAllVariables) {
        return null;
    }


    public Map!(string, VariableInstance) getVariableInstancesLocal() {
        return null;
    }


    public Map!(string, VariableInstance) getVariableInstancesLocal(Collection!string variableNames) {
        return null;
    }


    public Map!(string, VariableInstance) getVariableInstancesLocal(Collection!string variableNames, bool fetchAllVariables) {
        return null;
    }


    public VariableInstance getVariableInstance(string variableName) {
        return null;
    }


    public VariableInstance getVariableInstance(string variableName, bool fetchAllVariables) {
        return null;
    }


    public VariableInstance getVariableInstanceLocal(string variableName) {
        return null;
    }


    public VariableInstance getVariableInstanceLocal(string variableName, bool fetchAllVariables) {
        return null;
    }



    public Set!string getVariableNames() {
        return Collections.emptySet!string;
    }


    public Set!string getVariableNamesLocal() {
        return null;
    }


    public void setVariable(string variableName, Object value) {
        //throw new UnsupportedOperationException("No execution active, no variables can be set");
    }


    public void setVariable(string variableName, Object value, bool fetchAllVariables) {
       // throw new UnsupportedOperationException("No execution active, no variables can be set");
    }


    public Object setVariableLocal(string variableName, Object value) {
        //throw new UnsupportedOperationException("No execution active, no variables can be set");
    }


    public Object setVariableLocal(string variableName, Object value, bool fetchAllVariables) {
       // throw new UnsupportedOperationException("No execution active, no variables can be set");
    }


    public void setVariables(Map!(string, Object) variables) {
        //throw new UnsupportedOperationException("No execution active, no variables can be set");
    }


    public void setVariablesLocal(Map!(string, Object) variables) {
        //throw new UnsupportedOperationException("No execution active, no variables can be set");
    }


    public bool hasVariables() {
        return false;
    }


    public bool hasVariablesLocal() {
        return false;
    }


    public bool hasVariable(string variableName) {
        return false;
    }


    public bool hasVariableLocal(string variableName) {
        return false;
    }

    public void createVariableLocal(string variableName, Object value) {
       // throw new UnsupportedOperationException("No execution active, no variables can be created");
    }

    public void createVariablesLocal(Map!(string, Object) variables) {
        //throw new UnsupportedOperationException("No execution active, no variables can be created");
    }


    public void removeVariable(string variableName) {
       // throw new UnsupportedOperationException("No execution active, no variables can be removed");
    }


    public void removeVariableLocal(string variableName) {
       // throw new UnsupportedOperationException("No execution active, no variables can be removed");
    }


    public void removeVariables() {
       // throw new UnsupportedOperationException("No execution active, no variables can be removed");
    }


    public void removeVariablesLocal() {
       // throw new UnsupportedOperationException("No execution active, no variables can be removed");
    }


    public void removeVariables(Collection!string variableNames) {
      //  throw new UnsupportedOperationException("No execution active, no variables can be removed");
    }


    public void removeVariablesLocal(Collection!string variableNames) {
       // throw new UnsupportedOperationException("No execution active, no variables can be removed");
    }


    public void setTransientVariablesLocal(Map!(string, Object) transientVariables) {
       // throw new UnsupportedOperationException("No execution active, no variables can be set");
    }


    public void setTransientVariableLocal(string variableName, Object variableValue) {
        throw new UnsupportedOperationException("No execution active, no variables can be set");
    }


    public void setTransientVariables(Map!(string, Object) transientVariables) {
       // throw new UnsupportedOperationException("No execution active, no variables can be set");
    }


    public void setTransientVariable(string variableName, Object variableValue) {
        //throw new UnsupportedOperationException("No execution active, no variables can be set");
    }


    public Object getTransientVariableLocal(string variableName) {
        return null;
    }


    public Map!(string, Object) getTransientVariablesLocal() {
        return null;
    }


    public Object getTransientVariable(string variableName) {
        return null;
    }


    public Map!(string, Object) getTransientVariables() {
        return null;
    }


    public void removeTransientVariableLocal(string variableName) {
      //  throw new UnsupportedOperationException("No execution active, no variables can be removed");
    }


    public void removeTransientVariablesLocal() {
      //  throw new UnsupportedOperationException("No execution active, no variables can be removed");
    }


    public void removeTransientVariable(string variableName) {
       // throw new UnsupportedOperationException("No execution active, no variables can be removed");
    }


    public void removeTransientVariables() {
      //  throw new UnsupportedOperationException("No execution active, no variables can be removed");
    }


    public string getTenantId() {
        return null;
    }
}
