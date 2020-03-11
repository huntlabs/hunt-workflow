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



import hunt.collection.ArrayList;
import hunt.collection.List;

import org.kie.api.runtime.rule.AgendaFilter;
import org.kie.api.runtime.rule.Match;

/**
 * @author Tijs Rademakers
 */
class RulesAgendaFilter implements AgendaFilter {

    protected List!string suffixList = new ArrayList<>();
    protected bool accept;

    public RulesAgendaFilter() {
    }

    @Override
    public bool accept(Match match) {
        string ruleName = match.getRule().getName();
        for (string suffix : suffixList) {
            if (ruleName.endsWith(suffix)) {
                return this.accept;
            }
        }
        return !this.accept;
    }

    public void addSuffic(string suffix) {
        this.suffixList.add(suffix);
    }

    public void setAccept(bool accept) {
        this.accept = accept;
    }
}
