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

//          Copyright linse 2020.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)}

module flow.common.FlowableVersion;





import hunt.collection.Collections;
import hunt.collection.List;

/**
 * This class is used for auto-upgrade purposes.
 *
 * The idea is that instances of this class are put in a sequential order, and that the current version is determined from the ACT_GE_PROPERTY table.
 *
 * Since sometimes in the past, a version is ambiguous (eg. 5.12 => 5.12, 5.12.1, 5.12T) this class act as a wrapper with a smarter matches() method.
 *
 * @author Joram Barrez
 */
class FlowableVersion {

    public string mainVersion;
    protected List!string alternativeVersionStrings;

    this(string mainVersion) {
        this.mainVersion = mainVersion;
        this.alternativeVersionStrings = Collections.singletonList(mainVersion);
    }

    this(string mainVersion, List!string alternativeVersionStrings) {
        this.mainVersion = mainVersion;
        this.alternativeVersionStrings = alternativeVersionStrings;
    }

    public string getMainVersion() {
        return mainVersion;
    }

    public bool matches(string ver) {
        if (ver == (mainVersion)) {
            return true;
        } else if (!alternativeVersionStrings.isEmpty()) {
            return alternativeVersionStrings.contains(ver);
        } else {
            return false;
        }
    }

    override
     size_t toHash() @trusted nothrow{
        size_t result = 0;
        result = 31 * result + (mainVersion !is null ? hashOf(mainVersion) : 0);
        result = 31 * result + (alternativeVersionStrings !is null ? alternativeVersionStrings.toHash() : 0);
        return result;
    }

    override
    public bool opEquals(Object obj) {
        if (cast(FlowableVersion)obj is null) {
            return false;
        }
        FlowableVersion other = cast(FlowableVersion) obj;
        bool mainVersionEqual = (mainVersion == (other.mainVersion));
        if (!mainVersionEqual) {
            return false;
        } else {
            if (alternativeVersionStrings !is null) {
                return alternativeVersionStrings == (other.alternativeVersionStrings);
            } else {
                return other.alternativeVersionStrings is null;
            }
        }
    }

}
