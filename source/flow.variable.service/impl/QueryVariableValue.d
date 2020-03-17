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

module flow.variable.service.impl.QueryVariableValue;
import flow.common.api.FlowableIllegalArgumentException;
import flow.variable.service.api.types.VariableType;
import flow.variable.service.api.types.VariableTypes;
import flow.variable.service.impl.persistence.entity.VariableInstanceEntity;
import flow.variable.service.impl.types.ByteArrayType;
import flow.variable.service.impl.types.JPAEntityListVariableType;
import flow.variable.service.impl.types.JPAEntityVariableType;
import flow.variable.service.impl.util.CommandContextUtil;
import flow.variable.service.impl.QueryOperator;
/**
 * Represents a variable value used in queries.
 *
 * @author Frederik Heremans
 */
class QueryVariableValue  {
    private string name;
    private Object value;
    private QueryOperator operator;

    private VariableInstanceEntity variableInstanceEntity;
    private bool local;

    this(string name, Object value, QueryOperator operator, bool local) {
        this.name = name;
        this.value = value;
        this.operator = operator;
        this.local = local;
    }

    public void initialize(VariableTypes types) {
        if (variableInstanceEntity is null) {
            VariableType type = types.findVariableType(value);
            if (type instanceof ByteArrayType) {
                throw new FlowableIllegalArgumentException("Variables of type ByteArray cannot be used to query");
            } else if (type instanceof JPAEntityVariableType && operator != QueryOperator.EQUALS) {
                throw new FlowableIllegalArgumentException("JPA entity variables can only be used in 'variableValueEquals'");
            } else if (type instanceof JPAEntityListVariableType) {
                throw new FlowableIllegalArgumentException("Variables containing a list of JPA entities cannot be used to query");
            } else {
                // Type implementation determines which fields are set on the entity
                variableInstanceEntity = CommandContextUtil.getVariableInstanceEntityManager().create(name, type, value);
            }
        }
    }

    public string getName() {
        return name;
    }

    public string getOperator() {
        if (operator !is null) {
            return operator.toString();
        }
        return QueryOperator.EQUALS.toString();
    }

    public string getTextValue() {
        if (variableInstanceEntity !is null) {
            return variableInstanceEntity.getTextValue();
        }
        return null;
    }

    public long getLongValue() {
        if (variableInstanceEntity !is null) {
            return variableInstanceEntity.getLongValue();
        }
        return null;
    }

    public double getDoubleValue() {
        if (variableInstanceEntity !is null) {
            return variableInstanceEntity.getDoubleValue();
        }
        return null;
    }

    public string getTextValue2() {
        if (variableInstanceEntity !is null) {
            return variableInstanceEntity.getTextValue2();
        }
        return null;
    }

    public string getType() {
        if (variableInstanceEntity !is null) {
            return variableInstanceEntity.getType().getTypeName();
        }
        return null;
    }

    public bool isLocal() {
        return local;
    }
}
