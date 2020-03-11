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



import hunt.collection.HashMap;
import hunt.collection.Map;

import flow.common.api.query.QueryProperty;
import flow.engine.repository.ModelQuery;

/**
 * Contains the possible properties that can be used in a {@link ModelQuery}.
 *
 * @author Tijs Rademakers
 * @author Joram Barrez
 */
class ModelQueryProperty implements QueryProperty {

    private static final long serialVersionUID = 1L;

    private static final Map<string, ModelQueryProperty> properties = new HashMap<>();

    public static final ModelQueryProperty MODEL_CATEGORY = new ModelQueryProperty("RES.CATEGORY_");
    public static final ModelQueryProperty MODEL_ID = new ModelQueryProperty("RES.ID_");
    public static final ModelQueryProperty MODEL_VERSION = new ModelQueryProperty("RES.VERSION_");
    public static final ModelQueryProperty MODEL_NAME = new ModelQueryProperty("RES.NAME_");
    public static final ModelQueryProperty MODEL_CREATE_TIME = new ModelQueryProperty("RES.CREATE_TIME_");
    public static final ModelQueryProperty MODEL_LAST_UPDATE_TIME = new ModelQueryProperty("RES.LAST_UPDATE_TIME_");
    public static final ModelQueryProperty MODEL_KEY = new ModelQueryProperty("RES.KEY_");
    public static final ModelQueryProperty MODEL_TENANT_ID = new ModelQueryProperty("RES.TENANT_ID_");

    private string name;

    public ModelQueryProperty(string name) {
        this.name = name;
        properties.put(name, this);
    }

    @Override
    public string getName() {
        return name;
    }

    public static ModelQueryProperty findByName(string propertyName) {
        return properties.get(propertyName);
    }

}
