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
module flow.variable.service.impl.persistence.entity.VariableScopeImpl;

import flow.variable.service.impl.persistence.entity.TransientVariableInstance;
import flow.variable.service.impl.persistence.entity.VariableInstanceEntityManager;
import hunt.collection.ArrayList;
import hunt.collection;
import hunt.collection.HashMap;
import hunt.collection.HashSet;
import hunt.collection.List;
import hunt.collection.Map;
import hunt.collection.Set;

import flow.common.api.FlowableException;
import flow.common.api.deleg.event.FlowableEngineEventType;
import flow.common.context.Context;
import flow.common.interceptor.CommandContext;
//import flow.common.javax.el.ELContext;
//import flow.common.logging.LoggingSessionConstants;
//import flow.common.logging.LoggingSessionUtil;
import flow.common.persistence.entity.AbstractEntity;
import flow.variable.service.api.deleg.VariableScope;
import flow.variable.service.api.persistence.entity.VariableInstance;
import flow.variable.service.api.types.VariableType;
import flow.variable.service.api.types.VariableTypes;
import flow.variable.service.VariableServiceConfiguration;
import flow.variable.service.event.impl.FlowableVariableEventBuilder;
import flow.variable.service.impl.util.CommandContextUtil;
//import flow.variable.service.impl.util.VariableLoggingSessionUtil;
import flow.variable.service.impl.persistence.entity.VariableInstanceEntity;
import hunt.Exceptions;
import  std.algorithm;
//import com.fasterxml.jackson.databind.node.ObjectNode;

/**
 * @author Tom Baeyens
 * @author Joram Barrez
 * @author Tijs Rademakers
 * @author Saeid Mirzaei
 */
abstract class VariableScopeImpl : AbstractEntity ,  VariableScope {

    // The cache used when fetching all variables
    private Map!(string, VariableInstanceEntity) _variableInstances; // needs to be null, the logic depends on it for checking if vars were already fetched

    // The cache is used when fetching/setting specific variables
  private Map!(string, VariableInstanceEntity) _usedVariablesCache  ;//= new HashMap<>();

  private Map!(string, VariableInstance) transientVariables;

    //protected ELContext cachedElContext;

    protected abstract Collection!VariableInstanceEntity loadVariableInstances();

    protected abstract VariableScopeImpl getParentVariableScope();

    protected abstract void initializeVariableInstanceBackPointer(VariableInstanceEntity variableInstance);

   // protected abstract void addLoggingSessionInfo(ObjectNode loggingNode);
    public Map!(string, VariableInstanceEntity) variableInstances()
    {
        return _variableInstances;
    }

    public Map!(string, VariableInstanceEntity) usedVariablesCache()
    {
        return _usedVariablesCache;
    }

    this()
    {
      _usedVariablesCache = new HashMap!(string, VariableInstanceEntity);
    }

    protected void ensureVariableInstancesInitialized() {
        if (_variableInstances is null) {
            _variableInstances = new HashMap!(string, VariableInstanceEntity)();

            CommandContext commandContext = Context.getCommandContext();
            if (commandContext is null) {
                throw new FlowableException("lazy loading outside command context");
            }
            Collection!VariableInstanceEntity variableInstancesList = loadVariableInstances();
            foreach (VariableInstanceEntity variableInstance ; variableInstancesList) {
                _variableInstances.put(variableInstance.getName(), variableInstance);
            }
        }
    }

    /**
     * Only to be used when creating a new entity, to avoid an extra call to the database.
     */
    public void internalSetVariableInstances(Map!(string, VariableInstanceEntity) _variableInstances) {
        this._variableInstances = _variableInstances;
    }


    public Map!(string, Object) getVariables() {
        return collectVariables(new HashMap!(string, Object)());
    }


    public Map!(string, VariableInstance) getVariableInstances() {
        return collectVariableInstances(new HashMap!(string, VariableInstance)());
    }


    public Map!(string, Object) getVariables(Collection!string variableNames) {
        return getVariables(variableNames, true);
    }


    public Map!(string, VariableInstance) getVariableInstances(Collection!string variableNames) {
        return getVariableInstances(variableNames, true);
    }


    public Map!(string, Object) getVariables(Collection!string variableNames, bool fetchAllVariables) {

        Map!(string, Object) requestedVariables = new HashMap!(string, Object)();
        Set!string variableNamesToFetch = new HashSet!string(variableNames);

        // Transient variables 'shadow' any existing variables.
        // The values in the fetch-cache will be more recent, so they can override any existing ones
        foreach (string variableName ; variableNames) {
            if (transientVariables !is null && transientVariables.containsKey(variableName)) {
                requestedVariables.put(variableName, transientVariables.get(variableName).getValue());
                variableNamesToFetch.remove(variableName);
            } else if (_usedVariablesCache.containsKey(variableName)) {
                requestedVariables.put(variableName, _usedVariablesCache.get(variableName).getValue());
                variableNamesToFetch.remove(variableName);
            }
        }

        if (fetchAllVariables) {

            // getVariables() will go up the execution hierarchy, no need to do
            // it here also, the cached values will already be applied too
            Map!(string, Object) allVariables = getVariables();
            foreach (string variableName ; variableNamesToFetch) {
                requestedVariables.put(variableName, allVariables.get(variableName));
            }
            return requestedVariables;

        } else {

            // Go up if needed
            VariableScope parent = getParentVariableScope();
            if (parent !is null) {
                requestedVariables.putAll(parent.getVariables(variableNamesToFetch, fetchAllVariables));
            }

            // Fetch variables on this scope
            List!VariableInstanceEntity variables = getSpecificVariables(variableNamesToFetch);
            foreach (VariableInstanceEntity variable ; variables) {
                requestedVariables.put(variable.getName(), variable.getValue());
            }

            return requestedVariables;

        }

    }


    public Map!(string, VariableInstance) getVariableInstances(Collection!string variableNames, bool fetchAllVariables) {

        Map!(string, VariableInstance) requestedVariables = new HashMap!(string, VariableInstance)();
        Set!string variableNamesToFetch = new HashSet!string(variableNames);

        // The values in the fetch-cache will be more recent, so they can override any existing ones
        foreach (string variableName ; variableNames) {
            if (transientVariables !is null && transientVariables.containsKey(variableName)) {
                requestedVariables.put(variableName, transientVariables.get(variableName));
                variableNamesToFetch.remove(variableName);
            } else if (_usedVariablesCache.containsKey(variableName)) {
                requestedVariables.put(variableName, _usedVariablesCache.get(variableName));
                variableNamesToFetch.remove(variableName);
            }
        }

        if (fetchAllVariables) {

            // getVariables() will go up the execution hierarchy, no need to do it here
            // also, the cached values will already be applied too
            Map!(string, VariableInstance) allVariables = getVariableInstances();
            foreach (string variableName ; variableNamesToFetch) {
                requestedVariables.put(variableName, allVariables.get(variableName));
            }
            return requestedVariables;

        } else {

            // Go up if needed
            VariableScope parent = getParentVariableScope();
            if (parent !is null) {
                requestedVariables.putAll(parent.getVariableInstances(variableNamesToFetch, fetchAllVariables));
            }

            // Fetch variables on this scope
            List!VariableInstanceEntity variables = getSpecificVariables(variableNamesToFetch);
            foreach (VariableInstanceEntity variable ; variables) {
                requestedVariables.put(variable.getName(), variable);
            }

            return requestedVariables;

        }

    }

    protected Map!(string, Object) collectVariables(HashMap!(string, Object) variables) {
        ensureVariableInstancesInitialized();
        VariableScopeImpl parentScope = getParentVariableScope();
        if (parentScope !is null) {
            variables.putAll(parentScope.collectVariables(variables));
        }

        foreach (VariableInstanceEntity variableInstance ; _variableInstances.values()) {
            variables.put(variableInstance.getName(), variableInstance.getValue());
        }

        foreach (MapEntry!(string, VariableInstanceEntity) variableName ; _usedVariablesCache) {
            variables.put(variableName.getKey(), _usedVariablesCache.get(variableName.getKey()).getValue());
        }

        if (transientVariables !is null) {
            foreach (MapEntry!(string, VariableInstance) variableName ; transientVariables) {
                variables.put(variableName.getKey(), transientVariables.get(variableName.getKey()).getValue());
            }
        }

        return variables;
    }

    protected Map!(string, VariableInstance) collectVariableInstances(HashMap!(string, VariableInstance) variables) {
        ensureVariableInstancesInitialized();
        VariableScopeImpl parentScope = getParentVariableScope();
        if (parentScope !is null) {
            variables.putAll(parentScope.collectVariableInstances(variables));
        }

        foreach (VariableInstance variableInstance ; _variableInstances.values()) {
            variables.put(variableInstance.getName(), variableInstance);
        }

        foreach (MapEntry!(string, VariableInstanceEntity) variableName ; _usedVariablesCache) {
            variables.put(variableName.getKey(), _usedVariablesCache.get(variableName.getKey()));
        }

        if (transientVariables !is null) {
            variables.putAll(transientVariables);
        }

        return variables;
    }


    public Object getVariable(string variableName) {
        return getVariable(variableName, true);
    }


    public VariableInstance getVariableInstance(string variableName) {
        return getVariableInstance(variableName, true);
    }

    /**
     * The same operation as {@link VariableScopeImpl#getVariable(string)}, but with an extra parameter to indicate whether or not all variables need to be fetched.
     *
     * Note that the default way (because of backwards compatibility) is to fetch all the variables when doing a get/set of variables. So this means 'true' is the default value for this method, and in
     * fact it will simply delegate to {@link #getVariable(string)}. This can also be the most performant, if you're doing a lot of variable gets in the same transaction (eg in service tasks).
     *
     * In case 'false' is used, only the specific variable will be fetched.
     */

    public Object getVariable(string variableName, bool fetchAllVariables) {
        Object value = null;
        VariableInstance variable = getVariableInstance(variableName, fetchAllVariables);
        if (variable !is null) {
            value = variable.getValue();
        }
        return value;
    }


    public VariableInstance getVariableInstance(string variableName, bool fetchAllVariables) {

        // Transient variable
        if (transientVariables !is null && transientVariables.containsKey(variableName)) {
            return transientVariables.get(variableName);
        }

        // Check the local single-fetch cache
        if (_usedVariablesCache.containsKey(variableName)) {
            return _usedVariablesCache.get(variableName);
        }

        if (fetchAllVariables) {
            ensureVariableInstancesInitialized();
            VariableInstanceEntity variableInstance = _variableInstances.get(variableName);
            if (variableInstance !is null) {
                return variableInstance;
            }

            // Go up the hierarchy
            VariableScope parentScope = getParentVariableScope();
            if (parentScope !is null) {
                return parentScope.getVariableInstance(variableName, true);
            }

            return null;

        } else {

            if (_variableInstances !is null && _variableInstances.containsKey(variableName)) {
                return _variableInstances.get(variableName);
            }

            VariableInstanceEntity variable = getSpecificVariable(variableName);
            if (variable !is null) {
                _usedVariablesCache.put(variableName, variable);
                return variable;
            }

            // Go up the hierarchy
            VariableScope parentScope = getParentVariableScope();
            if (parentScope !is null) {
                return parentScope.getVariableInstance(variableName, false);
            }

            return null;

        }
    }

    protected abstract VariableInstanceEntity getSpecificVariable(string variableName);


    public Object getVariableLocal(string variableName) {
        return getVariableLocal(variableName, true);
    }


    public VariableInstance getVariableInstanceLocal(string variableName) {
        return getVariableInstanceLocal(variableName, true);
    }


    public Object getVariableLocal(string variableName, bool fetchAllVariables) {
        Object value = null;
        VariableInstance variable = getVariableInstanceLocal(variableName, fetchAllVariables);
        if (variable !is null) {
            value = variable.getValue();
        }
        return value;
    }


    public VariableInstance getVariableInstanceLocal(string variableName, bool fetchAllVariables) {

        if (transientVariables !is null && transientVariables.containsKey(variableName)) {
            return transientVariables.get(variableName);
        }

        if (_usedVariablesCache.containsKey(variableName)) {
            return _usedVariablesCache.get(variableName);
        }

        if (fetchAllVariables) {

            ensureVariableInstancesInitialized();

            VariableInstanceEntity variableInstance = _variableInstances.get(variableName);
            if (variableInstance !is null) {
                return variableInstance;
            }
            return null;

        } else {

            if (_variableInstances !is null && _variableInstances.containsKey(variableName)) {
                VariableInstanceEntity variable = _variableInstances.get(variableName);
                if (variable !is null) {
                    return _variableInstances.get(variableName);
                }
            }

            VariableInstanceEntity variable = getSpecificVariable(variableName);
            if (variable !is null) {
                _usedVariablesCache.put(variableName, variable);
                return variable;
            }

            return null;
        }
    }


    public bool hasVariables() {
        if (transientVariables !is null && !transientVariables.isEmpty()) {
            return true;
        }

        ensureVariableInstancesInitialized();
        if (!_variableInstances.isEmpty()) {
            return true;
        }
        VariableScope parentScope = getParentVariableScope();
        if (parentScope !is null) {
            return parentScope.hasVariables();
        }
        return false;
    }


    public bool hasVariablesLocal() {
        if (transientVariables !is null && !transientVariables.isEmpty()) {
            return true;
        }
        ensureVariableInstancesInitialized();
        return !_variableInstances.isEmpty();
    }


    public bool hasVariable(string variableName) {
        if (hasVariableLocal(variableName)) {
            return true;
        }
        VariableScope parentScope = getParentVariableScope();
        if (parentScope !is null) {
            return parentScope.hasVariable(variableName);
        }
        return false;
    }


    public bool hasVariableLocal(string variableName) {
        if (transientVariables !is null && transientVariables.containsKey(variableName)) {
            return true;
        }
        ensureVariableInstancesInitialized();
        return _variableInstances.containsKey(variableName);
    }

    protected Set!string collectVariableNames(Set!string variableNames) {
        if (transientVariables !is null) {
            foreach(MapEntry!(string, VariableInstance) entry ; transientVariables)
            {
              variableNames.add(entry.getKey());
            }
            //variableNames.addAll(transientVariables.keySet());
        }

        ensureVariableInstancesInitialized();
        VariableScopeImpl parentScope = getParentVariableScope();
        if (parentScope !is null) {
            variableNames.addAll(parentScope.collectVariableNames(variableNames));
        }
        foreach (VariableInstanceEntity variableInstance ; _variableInstances.values()) {
            variableNames.add(variableInstance.getName());
        }
        return variableNames;
    }


    public Set!string getVariableNames() {
        return collectVariableNames(new HashSet!string());
    }


    public Map!(string, Object) getVariablesLocal() {
        Map!(string, Object) variables = new HashMap!(string, Object)();
        ensureVariableInstancesInitialized();
        foreach (VariableInstanceEntity variableInstance ; _variableInstances.values()) {
            variables.put(variableInstance.getName(), variableInstance.getValue());
        }
        foreach (MapEntry!(string, VariableInstanceEntity) variableName ; _usedVariablesCache) {
            variables.put(variableName.getKey(), _usedVariablesCache.get(variableName.getKey()).getValue());
        }
        if (transientVariables !is null) {
            foreach (MapEntry!(string, VariableInstance) variableName ; transientVariables) {
                variables.put(variableName.getKey(), transientVariables.get(variableName.getKey()).getValue());
            }
        }
        return variables;
    }


    public Map!(string, VariableInstance) getVariableInstancesLocal() {
        Map!(string, VariableInstance) variables = new HashMap!(string, VariableInstance)();
        ensureVariableInstancesInitialized();
        foreach (VariableInstanceEntity variableInstance ; _variableInstances.values()) {
            variables.put(variableInstance.getName(), variableInstance);
        }
        foreach (MapEntry!(string, VariableInstanceEntity) variableName ; _usedVariablesCache) {
            variables.put(variableName.getKey(), _usedVariablesCache.get(variableName.getKey()));
        }
        if (transientVariables !is null) {
            variables.putAll(transientVariables);
        }
        return variables;
    }


    public Map!(string, Object) getVariablesLocal(Collection!string variableNames) {
        return getVariablesLocal(variableNames, true);
    }


    public Map!(string, VariableInstance) getVariableInstancesLocal(Collection!string variableNames) {
        return getVariableInstancesLocal(variableNames, true);
    }


    public Map!(string, Object) getVariablesLocal(Collection!string variableNames, bool fetchAllVariables) {
        Map!(string, Object) requestedVariables = new HashMap!(string, Object)();

        // The values in the fetch-cache will be more recent, so they can override any existing ones
        Set!string variableNamesToFetch = new HashSet!string(variableNames);
        foreach (string variableName ; variableNames) {
            if (transientVariables !is null && transientVariables.containsKey(variableName)) {
                requestedVariables.put(variableName, transientVariables.get(variableName).getValue());
                variableNamesToFetch.remove(variableName);
            } else if (_usedVariablesCache.containsKey(variableName)) {
                requestedVariables.put(variableName, _usedVariablesCache.get(variableName).getValue());
                variableNamesToFetch.remove(variableName);
            }
        }

        if (fetchAllVariables) {

            Map!(string, Object) allVariables = getVariablesLocal();
            foreach (string variableName ; variableNamesToFetch) {
                requestedVariables.put(variableName, allVariables.get(variableName));
            }

        } else {

            List!VariableInstanceEntity variables = getSpecificVariables(variableNamesToFetch);
            foreach (VariableInstanceEntity variable ; variables) {
                requestedVariables.put(variable.getName(), variable.getValue());
            }

        }

        return requestedVariables;
    }


    public Map!(string, VariableInstance) getVariableInstancesLocal(Collection!string variableNames, bool fetchAllVariables) {
        Map!(string, VariableInstance) requestedVariables = new HashMap!(string, VariableInstance)();

        // The values in the fetch-cache will be more recent, so they can override any existing ones
        Set!string variableNamesToFetch = new HashSet!string(variableNames);
        foreach (string variableName ; variableNames) {
            if (transientVariables !is null && transientVariables.containsKey(variableName)) {
                requestedVariables.put(variableName, transientVariables.get(variableName));
                variableNamesToFetch.remove(variableName);
            } else if (_usedVariablesCache.containsKey(variableName)) {
                requestedVariables.put(variableName, _usedVariablesCache.get(variableName));
                variableNamesToFetch.remove(variableName);
            }
        }

        if (fetchAllVariables) {

            Map!(string, VariableInstance) allVariables = getVariableInstancesLocal();
            foreach (string variableName ; variableNamesToFetch) {
                requestedVariables.put(variableName, allVariables.get(variableName));
            }

        } else {

            List!VariableInstanceEntity variables = getSpecificVariables(variableNamesToFetch);
            foreach (VariableInstanceEntity variable ; variables) {
                requestedVariables.put(variable.getName(), variable);
            }

        }

        return requestedVariables;
    }

    protected abstract List!VariableInstanceEntity getSpecificVariables(Collection!string variableNames);


    public Set!string getVariableNamesLocal() {
        Set!string variableNames = new HashSet!string();
        if (transientVariables !is null) {
            foreach(MapEntry!(string, VariableInstance) entry ; transientVariables)
            {
              variableNames.add(entry.getKey());
            }
           // variableNames.addAll(transientVariables.keySet());
        }
        ensureVariableInstancesInitialized();
        foreach(MapEntry!(string, VariableInstanceEntity) entry ; _variableInstances)
        {
          variableNames.add(entry.getKey());
        }
       // variableNames.addAll(_variableInstances.keySet());
        return variableNames;
    }

    public Map!(string, VariableInstanceEntity) getVariableInstanceEntities() {
        ensureVariableInstancesInitialized();
        //return Collections.unmodifiableMap(_variableInstances);
        return _variableInstances;
    }

    public Map!(string, VariableInstanceEntity) getUsedVariablesCache() {
        return _usedVariablesCache;
    }

    public void createVariablesLocal(Map!(string, Object) variables) {
        if (variables !is null) {
            foreach (MapEntry!(string, Object) entry ; variables) {
                createVariableLocal(entry.getKey(), entry.getValue());
            }
        }
    }


    public void setVariables(Map!(string,Object) variables) {
        if (variables !is null) {
            foreach (MapEntry!(string,Object) variableName ; variables) {
                setVariable(variableName.getKey(), variables.get(variableName.getKey()));
            }
        }
    }


    public void setVariablesLocal(Map!(string, Object) variables) {
        if (variables !is null) {
            foreach (MapEntry!(string, Object) variableName ; variables) {
                setVariableLocal(variableName.getKey(), variables.get(variableName.getKey()));
            }
        }
    }


    public void removeVariables() {
        ensureVariableInstancesInitialized();
        //Set!string variableNames = new HashSet!string(_variableInstances.keySet());
        Set!string variableNames  = new HashSet!string;
        foreach(MapEntry!(string, VariableInstanceEntity) entry; _variableInstances)
        {
             variableNames.add(entry.getKey());
        }
        foreach (string variableName ; variableNames) {
            removeVariable(variableName);
        }
    }


    public void removeVariablesLocal() {
        List!string variableNames = new ArrayList!string(getVariableNamesLocal());
        foreach (string variableName ; variableNames) {
            removeVariableLocal(variableName);
        }
    }


    public void removeVariables(Collection!string variableNames) {
        if (variableNames !is null) {
            foreach (string variableName ; variableNames) {
                removeVariable(variableName);
            }
        }
    }


    public void removeVariablesLocal(Collection!string variableNames) {
        if (variableNames !is null) {
            foreach (string variableName ; variableNames) {
                removeVariableLocal(variableName);
            }
        }
    }


    public void setVariable(string variableName, Object value) {
        //implementationMissing(false);
        //if (isExpression(variableName)) {
        //    CommandContextUtil.getExpressionManager().
        //            createExpression(variableName).
        //            setValue(value, this);
        //} else {
        //    setVariable(variableName, value, true);
        //}
      setVariable(variableName, value, true);
    }

    /**
     * The default {@link #setVariable(string, Object)} fetches all variables (for historical and backwards compatible reasons) while setting the variables.
     *
     * Setting the fetchAllVariables parameter to true is the default behaviour (ie fetching all variables) Setting the fetchAllVariables parameter to false does not do that.
     *
     */

    public void setVariable(string variableName, Object value, bool fetchAllVariables) {

        if (fetchAllVariables) {

            // If it's in the cache, it's more recent
            if (_usedVariablesCache.containsKey(variableName)) {
                updateVariableInstance(_usedVariablesCache.get(variableName), value);
            }

            // If the variable exists on this scope, replace it
            if (hasVariableLocal(variableName)) {
                setVariableLocal(variableName, value, true);
                return;
            }

            // Otherwise, go up the hierarchy (we're trying to put it as high as possible)
            VariableScopeImpl parentVariableScope = getParentVariableScope();
            if (parentVariableScope !is null) {
                parentVariableScope.setVariable(variableName, value);
                return;
            }

            // We're as high as possible and the variable doesn't exist yet, so we're creating it
            createVariableLocal(variableName, value);

        } else {

            // Check local cache first
            if (_usedVariablesCache.containsKey(variableName)) {

                updateVariableInstance(_usedVariablesCache.get(variableName), value);

            } else if (_variableInstances !is null && _variableInstances.containsKey(variableName)) {

                updateVariableInstance(_variableInstances.get(variableName), value);

            } else {

                // Not in local cache, check if defined on this scope
                // Create it if it doesn't exist yet
                VariableInstanceEntity variable = getSpecificVariable(variableName);
                if (variable !is null) {
                    updateVariableInstance(variable, value);
                    _usedVariablesCache.put(variableName, variable);
                } else {

                    VariableScopeImpl parent = getParentVariableScope();
                    if (parent !is null) {
                        parent.setVariable(variableName, value, fetchAllVariables);
                        return;
                    }

                    variable = createVariableInstance(variableName, value);
                    _usedVariablesCache.put(variableName, variable);

                }

            }

        }

    }


    public Object setVariableLocal(string variableName, Object value) {
        return setVariableLocal(variableName, value, true);
    }

    /**
     * The default {@link #setVariableLocal(string, Object)} fetches all variables (for historical and backwards compatible reasons) while setting the variables.
     *
     * Setting the fetchAllVariables parameter to true is the default behaviour (ie fetching all variables) Setting the fetchAllVariables parameter to false does not do that.
     *
     */

    public Object setVariableLocal(string variableName, Object value, bool fetchAllVariables) {

        if (fetchAllVariables) {

            // If it's in the cache, it's more recent
            if (_usedVariablesCache.containsKey(variableName)) {
                updateVariableInstance(_usedVariablesCache.get(variableName), value);
            }

            ensureVariableInstancesInitialized();

            VariableInstanceEntity variableInstance = _variableInstances.get(variableName);
            if (variableInstance is null) {
                variableInstance = _usedVariablesCache.get(variableName);
            }

            if (variableInstance is null) {
                createVariableLocal(variableName, value);
            } else {
                updateVariableInstance(variableInstance, value);
            }

            return null;

        } else {

            if (_usedVariablesCache.containsKey(variableName)) {
                updateVariableInstance(_usedVariablesCache.get(variableName), value);
            } else if (_variableInstances !is null && _variableInstances.containsKey(variableName)) {
                updateVariableInstance(_variableInstances.get(variableName), value);
            } else {

                VariableInstanceEntity variable = getSpecificVariable(variableName);
                if (variable !is null) {
                    updateVariableInstance(variable, value);
                } else {
                    variable = createVariableInstance(variableName, value);
                }
                _usedVariablesCache.put(variableName, variable);

            }

            return null;

        }
    }

    /**
     * only called when a new variable is created on this variable scope. This method is also responsible for propagating the creation of this variable to the history.
     */
    protected void createVariableLocal(string variableName, Object value) {
        ensureVariableInstancesInitialized();

        if (_variableInstances.containsKey(variableName)) {
            throw new FlowableException("variable '" ~ variableName ~ "' already exists. Use setVariableLocal if you want to overwrite the value");
        }

        createVariableInstance(variableName, value);
    }


    public void removeVariable(string variableName) {
        ensureVariableInstancesInitialized();
        if (_variableInstances.containsKey(variableName)) {
            removeVariableLocal(variableName);
            return;
        }
        VariableScopeImpl parentVariableScope = getParentVariableScope();
        if (parentVariableScope !is null) {
            parentVariableScope.removeVariable(variableName);
        }
    }


    public void removeVariableLocal(string variableName) {
        ensureVariableInstancesInitialized();
        VariableInstanceEntity variableInstance = _variableInstances.remove(variableName);
        if (variableInstance !is null) {
            deleteVariableInstanceForExplicitUserCall(variableInstance);
        }
    }

    protected void deleteVariableInstanceForExplicitUserCall(VariableInstanceEntity variableInstance) {
        CommandContextUtil.getVariableInstanceEntityManager().dele(variableInstance);

        VariableServiceConfiguration variableServiceConfiguration = CommandContextUtil.getVariableServiceConfiguration();
        //if (variableServiceConfiguration.isLoggingSessionEnabled()) {
        //    ObjectNode loggingNode = VariableLoggingSessionUtil.addLoggingData("Variable '" + variableInstance.getName() + "' deleted", variableInstance);
        //    addLoggingSessionInfo(loggingNode);
        //    LoggingSessionUtil.addLoggingData(LoggingSessionConstants.TYPE_VARIABLE_DELETE, loggingNode);
        //}

        variableInstance.setValue(null);

        initializeVariableInstanceBackPointer(variableInstance);

        if (isPropagateToHistoricVariable()) {
            if (variableServiceConfiguration.getInternalHistoryVariableManager() !is null) {
                variableServiceConfiguration.getInternalHistoryVariableManager()
                    .recordVariableRemoved(variableInstance, variableServiceConfiguration.getClock().getCurrentTime());
            }
        }
    }

    protected void updateVariableInstance(VariableInstanceEntity variableInstance, Object value) {

        // Always check if the type should be altered. It's possible that the previous type is lower in the type
        // checking chain (e.g. serializable) and will return true on isAbleToStore(), even though another type
        // higher in the chain is eligible for storage.

        VariableTypes variableTypes = CommandContextUtil.getVariableServiceConfiguration().getVariableTypes();

        VariableType newType = variableTypes.findVariableType(value);

        Object oldVariableValue = variableInstance.getValue();
        string oldVariableType = variableInstance.getTypeName();

        if (newType !is null && newType != (variableInstance.getType())) {
            variableInstance.setValue(null);
            variableInstance.setType(newType);
            variableInstance.forceUpdate();
            variableInstance.setValue(value);
        } else {
            variableInstance.setValue(value);
        }

        initializeVariableInstanceBackPointer(variableInstance);

        VariableServiceConfiguration variableServiceConfiguration = CommandContextUtil.getVariableServiceConfiguration();
        if (isPropagateToHistoricVariable()) {
            if (variableServiceConfiguration.getInternalHistoryVariableManager() !is null) {
                variableServiceConfiguration.getInternalHistoryVariableManager()
                    .recordVariableUpdate(variableInstance, variableServiceConfiguration.getClock().getCurrentTime());
            }
        }

        // Dispatch event, if needed
        if (variableServiceConfiguration.isEventDispatcherEnabled()) {
            variableServiceConfiguration.getEventDispatcher().dispatchEvent(
                            FlowableVariableEventBuilder.createVariableEvent(FlowableEngineEventType.VARIABLE_UPDATED, variableInstance.getName(), value,
                                            variableInstance.getType(), variableInstance.getTaskId(), variableInstance.getExecutionId(),
                                            variableInstance.getProcessInstanceId(), variableInstance.getProcessDefinitionId(),
                                            variableInstance.getScopeId(), variableInstance.getScopeType()));
        }

        //if (variableServiceConfiguration.isLoggingSessionEnabled()) {
        //    ObjectNode loggingNode = VariableLoggingSessionUtil.addLoggingData("Variable '" + variableInstance.getName() + "' updated", variableInstance);
        //    addLoggingSessionInfo(loggingNode);
        //    loggingNode.put("oldVariableType", oldVariableType);
        //    VariableLoggingSessionUtil.addVariableValue(oldVariableValue, oldVariableType, "oldVariableRawValue", "oldVariableValue", loggingNode);
        //    LoggingSessionUtil.addLoggingData(LoggingSessionConstants.TYPE_VARIABLE_UPDATE, loggingNode);
        //}
    }

    protected VariableInstanceEntity createVariableInstance(string variableName, Object value) {
        VariableServiceConfiguration variableServiceConfiguration = CommandContextUtil.getVariableServiceConfiguration();
        VariableTypes variableTypes = variableServiceConfiguration.getVariableTypes();

        VariableType type = variableTypes.findVariableType(value);

        VariableInstanceEntityManager variableInstanceEntityManager = CommandContextUtil.getVariableInstanceEntityManager();
        VariableInstanceEntity variableInstance = variableInstanceEntityManager.create(variableName, type);
        initializeVariableInstanceBackPointer(variableInstance);

        // Set the value after initializing the back pointer
        variableInstance.setValue(value);
        variableInstanceEntityManager.insert(variableInstance);

        if (_variableInstances !is null) {
            _variableInstances.put(variableName, variableInstance);
        }

        if (isPropagateToHistoricVariable()) {
            if (variableServiceConfiguration.getInternalHistoryVariableManager() !is null) {
                variableServiceConfiguration.getInternalHistoryVariableManager()
                    .recordVariableCreate(variableInstance, variableServiceConfiguration.getClock().getCurrentTime());
            }
        }

        if (variableServiceConfiguration.isEventDispatcherEnabled()) {
            variableServiceConfiguration.getEventDispatcher().dispatchEvent(
                            FlowableVariableEventBuilder.createVariableEvent(FlowableEngineEventType.VARIABLE_CREATED, variableName, value,
                                            variableInstance.getType(), variableInstance.getTaskId(), variableInstance.getExecutionId(),
                                            variableInstance.getProcessInstanceId(), variableInstance.getProcessDefinitionId(),
                                            variableInstance.getScopeId(), variableInstance.getScopeType()));
        }

        //if (variableServiceConfiguration.isLoggingSessionEnabled()) {
        //    ObjectNode loggingNode = VariableLoggingSessionUtil.addLoggingData("Variable '" + variableInstance.getName() + "' created", variableInstance);
        //    addLoggingSessionInfo(loggingNode);
        //    LoggingSessionUtil.addLoggingData(LoggingSessionConstants.TYPE_VARIABLE_CREATE, loggingNode);
        //}

        return variableInstance;
    }

    /*
     * Transient variables
     */


    public void setTransientVariablesLocal(Map!(string, Object) transientVariables) {
        foreach (MapEntry!(string, Object) variableName ; transientVariables) {
            setTransientVariableLocal(variableName.getKey(), transientVariables.get(variableName.getKey()));
        }
    }


    public void setTransientVariableLocal(string variableName, Object variableValue) {
        if (transientVariables is null) {
            transientVariables = new HashMap!(string, VariableInstance)();
        }
        transientVariables.put(variableName, new TransientVariableInstance(variableName, variableValue));
    }


    public void setTransientVariables(Map!(string, Object) transientVariables) {
        foreach (MapEntry!(string, Object) variableName ; transientVariables) {
            setTransientVariable(variableName.getKey(), transientVariables.get(variableName.getKey()));
        }
    }


    public void setTransientVariable(string variableName, Object variableValue) {
        VariableScopeImpl parentVariableScope = getParentVariableScope();
        if (parentVariableScope !is null) {
            parentVariableScope.setTransientVariable(variableName, variableValue);
            return;
        }
        setTransientVariableLocal(variableName, variableValue);
    }


    public Object getTransientVariableLocal(string variableName) {
        if (transientVariables !is null && transientVariables.containsKey(variableName)) {
            return transientVariables.get(variableName).getValue();
        }
        return null;
    }


    public Map!(string, Object) getTransientVariablesLocal() {
        if (transientVariables !is null) {
            Map!(string, Object) variables = new HashMap!(string, Object)();
            foreach (MapEntry!(string, VariableInstance) variableName ; transientVariables) {
                variables.put(variableName.getKey(), transientVariables.get(variableName.getKey()).getValue());
            }
            return variables;
        } else {
            return Collections.emptyMap!(string, Object)();
        }
    }


    public Object getTransientVariable(string variableName) {
        if (transientVariables !is null && transientVariables.containsKey(variableName)) {
            return transientVariables.get(variableName).getValue();
        }

        VariableScopeImpl parentScope = getParentVariableScope();
        if (parentScope !is null) {
            return parentScope.getTransientVariable(variableName);
        }

        return null;
    }


    public Map!(string, Object) getTransientVariables() {
        return collectTransientVariables(new HashMap!(string, Object)());
    }

    protected Map!(string, Object) collectTransientVariables(HashMap!(string, Object) variables) {
        VariableScopeImpl parentScope = getParentVariableScope();
        if (parentScope !is null) {
            variables.putAll(parentScope.collectVariables(variables));
        }

        if (transientVariables !is null) {
            foreach (MapEntry!(string, VariableInstance) variableName ;transientVariables) {
                variables.put(variableName.getKey(), transientVariables.get(variableName.getKey()).getValue());
            }
        }

        return variables;
    }


    public void removeTransientVariableLocal(string variableName) {
        if (transientVariables !is null) {
            transientVariables.remove(variableName);
        }
    }


    public void removeTransientVariablesLocal() {
        if (transientVariables !is null) {
            transientVariables.clear();
        }
    }


    public void removeTransientVariable(string variableName) {
        if (transientVariables !is null && transientVariables.containsKey(variableName)) {
            removeTransientVariableLocal(variableName);
            return;
        }
        VariableScopeImpl parentVariableScope = getParentVariableScope();
        if (parentVariableScope !is null) {
            parentVariableScope.removeTransientVariable(variableName);
        }
    }


    public void removeTransientVariables() {
        removeTransientVariablesLocal();
        VariableScopeImpl parentVariableScope = getParentVariableScope();
        if (parentVariableScope !is null) {
            parentVariableScope.removeTransientVariablesLocal();
        }
    }

    /**
     * Return whether changes to the variables are progagated to the history storage.
     */
    protected abstract bool isPropagateToHistoricVariable();

    // getters and setters
    // //////////////////////////////////////////////////////

    //public ELContext getCachedElContext() {
    //    return cachedElContext;
    //}
    //
    //public void setCachedElContext(ELContext cachedElContext) {
    //    this.cachedElContext = cachedElContext;
    //}


    public  T getVariable(T)(string variableName) {
        return cast(T)(getVariable(variableName));
    }


    public T getVariableLocal(T)(string variableName) {
        return cast(T)(getVariableLocal(variableName));
    }

    protected bool isExpression(string variableName) {
        return startsWith(variableName, "${") || startsWith(variableName,"#{");
    }

}
