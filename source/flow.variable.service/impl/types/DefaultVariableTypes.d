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
module flow.variable.service.impl.types.DefaultVariableTypes;

import hunt.collection.ArrayList;
import hunt.collection.HashMap;
import hunt.collection.List;
import hunt.collection.Map;

import flow.common.api.FlowableException;
import flow.variable.service.api.types.VariableType;
import flow.variable.service.api.types.VariableTypes;
/**
 * @author Tom Baeyens
 */
class DefaultVariableTypes : VariableTypes {

    private  List!VariableType typesList ;//= new ArrayList<>();
    private  Map!(string, VariableType) typesMap  ;//= new HashMap<>();

    this()
    {
      typesList = new ArrayList!VariableType;
      typesMap = new HashMap!(string, VariableType);
    }

    public DefaultVariableTypes addType(VariableType type) {
        return addType(type, typesList.size());
    }


    public DefaultVariableTypes addType(VariableType type, int index) {
        typesList.add(index, type);
        typesMap.put(type.getTypeName(), type);
        return this;
    }

    public void setTypesList(List!VariableType typesList) {
        this.typesList.clear();
        this.typesList.addAll(typesList);
        this.typesMap.clear();
        foreach (VariableType type ; typesList) {
            typesMap.put(type.getTypeName(), type);
        }
    }


    public VariableType getVariableType(string typeName) {
        return typesMap.get(typeName);
    }


    public VariableType findVariableType(Object value) {
        foreach (VariableType type ; typesList) {
            if (type.isAbleToStore(value)) {
                return type;
            }
        }
        throw new FlowableException("couldn't find a variable type that is able to serialize " );
    }


    public int getTypeIndex(VariableType type) {
        return typesList.indexOf(type);
    }


    public int getTypeIndex(string typeName) {
        VariableType type = typesMap.get(typeName);
        if (type !is null) {
            return getTypeIndex(type);
        } else {
            return -1;
        }
    }


    public VariableTypes removeType(VariableType type) {
        typesList.remove(type);
        typesMap.remove(type.getTypeName());
        return this;
    }
}
