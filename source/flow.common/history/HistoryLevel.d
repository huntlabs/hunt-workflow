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

module flow.common.history.HistoryLevel;

 import hunt.Enum;
import std.concurrency : initOnce;
/**
 * Enum that contains all possible history-levels.
 *
 * @author Frederik Heremans
 */
class HistoryLevel : AbstractEnum!HistoryLevel {


    private  string key;


    static HistoryLevel  NONE() {
        __gshared HistoryLevel  inst;
        return initOnce!inst(new HistoryLevel("none" , 0));
    }
    static HistoryLevel  ACTIVITY() {
        __gshared HistoryLevel  inst;
        return initOnce!inst(new HistoryLevel("activity" , 1));
    }
    static HistoryLevel  AUDIT() {
        __gshared HistoryLevel  inst;
        return initOnce!inst(new HistoryLevel("audit" , 2));
    }
    static HistoryLevel  FULL() {
        __gshared HistoryLevel  inst;
        return initOnce!inst(new HistoryLevel("full" , 3));
    }
    static HistoryLevel[]  VALUES() {
        __gshared HistoryLevel []  inst;
        return initOnce!inst(inst = [NONE,ACTIVITY,AUDIT,FULL]);
    }
    this(string key , int val) {
        this.key = key;
        super(key,val);
    }

    /**
     * @param key
     *            string representation of level
     * @return {@link HistoryLevel} for the given key
     * @throws FlowableException
     *             when passed in key doesn't correspond to existing level
     */
    public static HistoryLevel getHistoryLevelForKey(string key) {
        foreach (HistoryLevel level ; VALUES()) {
            if (level.key.equals(key)) {
                return level;
            }
        }
        return null;
      //  throw new FlowableIllegalArgumentException("Illegal value for history-level: " + key);
    }

    /**
     * string representation of this history-level.
     */
    public string getKey() {
        return key;
    }

    /**
     * Checks if the given level is the same as, or higher in order than the level this method is executed on.
     */
    public bool isAtLeast(HistoryLevel level) {
        // Comparing enums actually compares the location of values declared in
        // the enum
        return this >= (level);
    }
}
