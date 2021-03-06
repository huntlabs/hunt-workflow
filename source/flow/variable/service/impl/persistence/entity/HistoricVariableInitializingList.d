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

module flow.variable.service.impl.persistence.entity.HistoricVariableInitializingList;

import hunt.collection.ArrayList;
import hunt.collection;

import flow.common.context.Context;
import flow.variable.service.impl.types.CacheableVariable;
//import flow.variable.service.impl.types.JPAEntityListVariableType;
//import flow.variable.service.impl.types.JPAEntityVariableType;
import flow.variable.service.impl.persistence.entity.HistoricVariableInstanceEntity;
/**
 * List that initialises binary variable values if command-context is active.
 *
 * @author Frederik Heremans
 */
class HistoricVariableInitializingList : ArrayList!HistoricVariableInstanceEntity {


    override
    public void add(int index, HistoricVariableInstanceEntity e) {
        super.add(index, e);
        initializeVariable(e);
    }

    override
    public bool add(HistoricVariableInstanceEntity e) {
        initializeVariable(e);
        return super.add(e);
    }

    override
    public bool addAll(Collection!HistoricVariableInstanceEntity c) {
        foreach (HistoricVariableInstanceEntity e ; c) {
            initializeVariable(e);
        }
        return super.addAll(c);
    }

    //override
    //public boolean addAll(int index, Collection<? extends HistoricVariableInstanceEntity> c) {
    //    for (HistoricVariableInstanceEntity e : c) {
    //        initializeVariable(e);
    //    }
    //    return super.addAll(index, c);
    //}

    /**
     * If the passed {@link HistoricVariableInstanceEntity} is a binary variable and the command-context is active, the variable value is fetched to ensure the byte-array is populated.
     */
    protected void initializeVariable(HistoricVariableInstanceEntity e) {
        if (Context.getCommandContext() !is null && e !is null && e.getVariableType() !is null) {
            e.getValue();

            // make sure JPA entities are cached for later retrieval
            //if (JPAEntityVariableType.TYPE_NAME.equals(e.getVariableType().getTypeName()) || JPAEntityListVariableType.TYPE_NAME.equals(e.getVariableType().getTypeName())) {
            //    ((CacheableVariable) e.getVariableType()).setForceCacheable(true);
            //}
        }
    }
}
