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
module flow.bpmn.converter.converter.util.CommaSplitter;

import hunt.collection.ArrayList;
import hunt.collection.List;
import core.stdc.string : strlen;
import std.string;
/**
 * @author Saeid Mirzaei, Tijs Rademakers
 */

class CommaSplitter {

    // split the given spring using commas if they are not inside an expression
    public static List!string splitCommas(string st) {
        List!string result = new ArrayList!string();
        int offset = 0;
        bool inExpression = false;
        auto ss = toStringz(st);
        for(int i = 0 ; i < st.length ; ++ i) {
            if (!inExpression && ss[i] == ',') {
                if ((i - offset) > 1) {
                    result.add(st[offset .. i]);
                }
                offset = i + 1;

            } else if ((ss[i] == '$' ||  ss[i] == '#') &&  ss[i + 1] == '{') {
                inExpression = true;

            } else if (ss[i] == '}') {
                inExpression = false;
            }
        }

        if ((st.length() - offset) > 1) {
            result.add(st[offset .. $]);
        }
        return result;
    }
}
