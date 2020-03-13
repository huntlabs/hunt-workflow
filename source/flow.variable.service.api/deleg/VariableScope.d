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

module flow.variable.service.api.deleg.VariableScope;


import hunt.collection;
import hunt.collection.Map;
import hunt.collection.Set;

import flow.common.api.variable.VariableContainer;
import flow.variable.service.api.persistence.entity.VariableInstance;

/**
 * Interface for class that acts as a scope for variables: i.e. the implementation can be used to set and get variables.
 *
 * Variables are typically stored on the 'highest parent'. For executions, this means that when called on an execution
 * the variable will be stored on the process instance execution. Variables can be stored on the actual scope itself though,
 * by calling the xxLocal methods.
 *
 * @author Tom Baeyens
 * @author Joram Barrez
 */
interface VariableScope : VariableContainer {

    /**
     * Returns all variables. This will include all variables of parent scopes too.
     */
    Map!(string, Object) getVariables();

    /**
     * Returns all variables, as instances of the {@link VariableInstance} interface, which gives more information than only the value (type, execution id, etc.)
     */
    Map!(string, VariableInstance) getVariableInstances();

    /**
     * Similar to {@link #getVariables()}, but limited to only the variables with the provided names.
     */
    Map!(string, Object) getVariables(Collection!string variableNames);

    /**
     * Similar to {@link #getVariableInstances()}, but limited to only the variables with the provided names.
     */
    Map!(string, VariableInstance) getVariableInstances(Collection!string variableNames);

    /**
     * Similar to {@link #getVariables(Collection))}, but with a flag that indicates that all variables should be fetched when fetching the specific variables.
     *
     * If set to false, only the specific variables will be fetched. Depending on the use case, this can be better for performance, as it avoids fetching and processing the other variables. However,
     * if the other variables are needed further on, getting them in one go is probably better (and the variables are cached during one {@link Command} execution).
     */
    Map!(string, Object) getVariables(Collection!string variableNames, bool fetchAllVariables);

    /**
     * Similar to {@link #getVariables(Collection, bool)} but returns the variables as instances of the {@link VariableInstance} interface, which gives more information than only the value
     * (type, execution id, etc.)
     */
    Map!(string, VariableInstance) getVariableInstances(Collection!string variableNames, bool fetchAllVariables);

    /**
     * Returns the variable local to this scope only. So, in contrary to {@link #getVariables()}, the variables from the parent scope won't be returned.
     */
    Map!(string, Object) getVariablesLocal();

    /**
     * Returns the variables local to this scope as instances of the {@link VariableInstance} interface, which provided additional information about the variable.
     */
    Map!(string, VariableInstance) getVariableInstancesLocal();

    /**
     * Similar to {@link #getVariables(Collection)}, but only for variables local to this scope.
     */
    Map!(string, Object) getVariablesLocal(Collection!string variableNames);

    /**
     * Similar to {@link #getVariableInstances(Collection)}, but only for variables local to this scope.
     */
    Map!(string, VariableInstance) getVariableInstancesLocal(Collection!string variableNames);

    /**
     * Similar to {@link #getVariables(Collection, bool)}, but only for variables local to this scope.
     */
    Map!(string, Object) getVariablesLocal(Collection!string variableNames, bool fetchAllVariables);

    /**
     * Similar to {@link #getVariableInstances(Collection, bool)}, but only for variables local to this scope.
     */
    Map!(string, VariableInstance) getVariableInstancesLocal(Collection!string variableNames, bool fetchAllVariables);

    /**
     * Returns the variable value for one specific variable. Will look in parent scopes when the variable does not exist on this particular scope.
     */
    Object getVariable(string variableName);

    /**
     * Similar to {@link #getVariable(string)}, but returns a {@link VariableInstance} instance, which contains more information than just the value.
     */
    VariableInstance getVariableInstance(string variableName);

    /**
     * Similar to {@link #getVariable(string)}, but has an extra flag that indicates whether or not all variables need to be fetched when getting one variable.
     *
     * By default true (for backwards compatibility reasons), which means that calling {@link #getVariable(string)} will fetch all variables, of the current scope and all parent scopes. Setting this
     * flag to false can thus be better for performance. However, variables are cached, and if other variables are used later on, setting this true might actually be better for performance.
     */
    Object getVariable(string variableName, bool fetchAllVariables);

    /**
     * Similar to {@link #getVariable(string, bool)}, but returns an instance of {@link VariableInstance}, which has some additional information beyond the value.
     */
    VariableInstance getVariableInstance(string variableName, bool fetchAllVariables);

    /**
     * Returns the value for the specific variable and only checks this scope and not any parent scope.
     */
    Object getVariableLocal(string variableName);

    /**
     * Similar to {@link #getVariableLocal(string)}, but returns an instance of {@link VariableInstance}, which has some additional information beyond the value.
     */
    VariableInstance getVariableInstanceLocal(string variableName);

    /**
     * Similar to {@link #getVariableLocal(string)}, but has an extra flag that indicates whether or not all variables need to be fetched when getting one variable.
     *
     * By default true (for backwards compatibility reasons), which means that calling {@link #getVariableLocal(string)} will fetch all variables, of the current scope. Setting this flag to false can
     * thus be better for performance. However, variables are cached, and if other variables are used later on, setting this true might actually be better for performance.
     */
    Object getVariableLocal(string variableName, bool fetchAllVariables);

    /**
     * Similar to {@link #getVariableLocal(string, bool)}, but returns an instance of {@link VariableInstance}, which has some additional information beyond the value.
     */
    VariableInstance getVariableInstanceLocal(string variableName, bool fetchAllVariables);

    /**
     * Typed version of the {@link #getVariable(string)} method.
     */
    //<T> T getVariable(string variableName, Class<T> variableClass);
    //
    ///**
    // * Typed version of the {@link #getVariableLocal(string)} method.
    // */
    //<T> T getVariableLocal(string variableName, Class<T> variableClass);

    /**
     * Returns all the names of the variables for this scope and all parent scopes.
     */
    Set!string getVariableNames();

    /**
     * Returns all the names of the variables for this scope (no parent scopes).
     */
    Set!string getVariableNamesLocal();

    /**
     * Sets the variable with the provided name to the provided value. In the case when variable name is an expression
     * which is resolved by expression manager, the value is set in the object resolved from the expression.
     *
     * <p>
     * A variable is set according to the following algorithm:
     *
     * <p>
     * <li>If variable name is an expression, resolve expression and set the value on the resolved object.</li>
     * <li>If this scope already contains a variable by the provided name as a <strong>local</strong> variable, its value is overwritten to the provided value.</li>
     * <li>If this scope does <strong>not</strong> contain a variable by the provided name as a local variable, the variable is set to this scope's parent scope, if there is one. If there is no parent
     * scope (meaning this scope is the root scope of the hierarchy it belongs to), this scope is used. This applies recursively up the parent scope chain until, if no scope contains a local variable
     * by the provided name, ultimately the root scope is reached and the variable value is set on that scope.</li>
     * <p>
     * In practice for most cases, this algorithm will set variables to the scope of the execution at the process instance’s root level, if there is no execution-local variable by the provided name.
     *
     * @param variableName
     *            the name of the variable to be set
     * @param value
     *            the value of the variable to be set
     */
    void setVariable(string variableName, Object value);

    /**
     * Similar to {@link #setVariable(string, Object)}, but with an extra flag to indicate whether all variables should be fetched while doing this or not.
     * Variable name expression is not resolved.
     *
     * The variable will be put on the highest possible scope. For an execution this is the process instance execution. If this is not wanted, use the {@link #setVariableLocal(string, Object)} method
     * instead.
     *
     * The default (e.g. when calling {@link #setVariable(string, Object)}), is <i>true</i>, for backwards compatibility reasons. However, in some use cases, it might make sense not to fetch any other
     * variables when setting one variable (for example when doing nothing more than just setting one variable).
     */
    void setVariable(string variableName, Object value, bool fetchAllVariables);

    /**
     * Similar to {@link #setVariable(string, Object)}, but the variable is set to this scope specifically. Variable name
     is handled as a variable name string without resolving an expression.
     */
    Object setVariableLocal(string variableName, Object value);

    /**
     * Similar to {@link #setVariableLocal(string, Object, value)}, but with an extra flag to indicate whether all variables should be fetched while doing this or not.
     */
    Object setVariableLocal(string variableName, Object value, bool fetchAllVariables);

    /**
     * Sets the provided variables to the variable scope.
     *
     * <p>
     * Variables are set according algorithm for {@link #setVariable(string, Object)}, applied separately to each variable.
     *
     * @param variables
     *            a map of keys and values for the variables to be set
     */
    void setVariables(Map!(string,Object) variables);

    /**
     * Similar to {@link #setVariables(Map)}, but the variable are set on this scope specifically.
     */
    void setVariablesLocal(Map!(string, Object) variables);

    /**
     * Returns whether this scope or any parent scope has variables.
     */
    bool hasVariables();

    /**
     * Returns whether this scope has variables.
     */
    bool hasVariablesLocal();

    /**
     * Returns whether this scope or any parent scope has a specific variable.
     */
    bool hasVariable(string variableName);

    /**
     * Returns whether this scope has a specific variable.
     */
    bool hasVariableLocal(string variableName);

    /**
     * Removes the variable and creates a new;@link HistoricVariableUpdateEntity}
     */
    void removeVariable(string variableName);

    /**
     * Removes the local variable and creates a new {@link HistoricVariableUpdate}.
     */
    void removeVariableLocal(string variableName);

    /**
     * Removes the variables and creates a new {@link HistoricVariableUpdate} for each of them.
     */
    void removeVariables(Collection!string variableNames);

    /**
     * Removes the local variables and creates a new {@link HistoricVariableUpdate} for each of them.
     */
    void removeVariablesLocal(Collection!string variableNames);

    /**
     * Removes the (local) variables and creates a new {@link HistoricVariableUpdate} for each of them.
     */
    void removeVariables();

    /**
     * Removes the (local) variables and creates a new {@link HistoricVariableUpdate} for each of them.
     */
    void removeVariablesLocal();

    /**
     * Similar to {@link #setVariable(string, Object)}, but the variable is transient:
     *
     * - no history is kept for the variable - the variable is only available until a waitstate is reached in the process - transient variables 'shadow' persistent variable (when getVariable('abc')
     * where 'abc' is both persistent and transient, the transient value is returned.
     */
    void setTransientVariable(string variableName, Object variableValue);

    /**
     * Similar to {@link #setVariableLocal(string, Object)}, but for a transient variable. See {@link #setTransientVariable(string, Object)} for the rules on 'transient' variables.
     */
    void setTransientVariableLocal(string variableName, Object variableValue);

    /**
     * Similar to {@link #setVariables(Map)}, but for transient variables. See {@link #setTransientVariable(string, Object)} for the rules on 'transient' variables.
     */
    void setTransientVariables(Map!(string, Object) transientVariables);

    /**
     * Similar to {@link #getVariable(string)}, including the searching via the parent scopes, but for transient variables only. See {@link #setTransientVariable(string, Object)} for the rules on
     * 'transient' variables.
     */
    Object getTransientVariable(string variableName);

    /**
     * Similar to {@link #getVariables()}, but for transient variables only. See {@link #setTransientVariable(string, Object)} for the rules on 'transient' variables.
     */
    Map!(string, Object) getTransientVariables();

    /**
     * Similar to {@link #setVariablesLocal(Map)}, but for transient variables. See {@link #setTransientVariable(string, Object)} for the rules on 'transient' variables.
     */
    void setTransientVariablesLocal(Map!(string, Object) transientVariables);

    /**
     * Similar to {@link #getVariableLocal(string)}, but for a transient variable. See {@link #setTransientVariable(string, Object)} for the rules on 'transient' variables.
     */
    Object getTransientVariableLocal(string variableName);

    /**
     * Similar to {@link #getVariableLocal(string)}, but for transient variables only. See {@link #setTransientVariable(string, Object)} for the rules on 'transient' variables.
     */
    Map!(string, Object) getTransientVariablesLocal();

    /**
     * Removes a specific transient variable (also searching parent scopes). See {@link #setTransientVariable(string, Object)} for the rules on 'transient' variables.
     */
    void removeTransientVariableLocal(string variableName);

    /**
     * Removes a specific transient variable. See {@link #setTransientVariable(string, Object)} for the rules on 'transient' variables.
     */
    void removeTransientVariable(string variableName);

    /**
     * Remove all transient variable of this scope and its parent scopes. See {@link #setTransientVariable(string, Object)} for the rules on 'transient' variables.
     */
    void removeTransientVariables();

    /**
     * Removes all local transient variables. See {@link #setTransientVariable(string, Object)} for the rules on 'transient' variables.
     */
    void removeTransientVariablesLocal();

}
