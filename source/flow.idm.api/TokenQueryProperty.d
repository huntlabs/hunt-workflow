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



import java.util.HashMap;
import java.util.Map;

import flow.common.api.query.QueryProperty;

/**
 * Contains the possible properties that can be used by the {@link TokenQuery}.
 * 
 * @author Tijs Rademakers
 */
class TokenQueryProperty implements QueryProperty {

    private static final long serialVersionUID = 1L;

    private static final Map<string, TokenQueryProperty> properties = new HashMap<>();

    public static final TokenQueryProperty TOKEN_ID = new TokenQueryProperty("RES.ID_");
    public static final TokenQueryProperty TOKEN_DATE = new TokenQueryProperty("RES.TOKEN_DATE_");

    private string name;

    public TokenQueryProperty(string name) {
        this.name = name;
        properties.put(name, this);
    }

    @Override
    public string getName() {
        return name;
    }

    public static TokenQueryProperty findByName(string propertyName) {
        return properties.get(propertyName);
    }

}
