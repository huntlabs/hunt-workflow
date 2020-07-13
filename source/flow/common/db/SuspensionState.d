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

module flow.common.db.SuspensionState;
import std.concurrency : initOnce;
/**
 * Contains a predefined set of states for process definitions and process instances
 *
 * @author Daniel Meyer
 */



interface SuspensionState {

    //SuspensionState ACTIVE = new SuspensionStateImpl(1, "active");
    //SuspensionState SUSPENDED = new SuspensionStateImpl(2, "suspended");


    int getStateCode();

    // default implementation ///////////////////////////////////////////////////
}

class SuspensionStateImpl : SuspensionState {

  public  int stateCode;
  protected  string name;

  this(int suspensionCode, string string) {
    this.stateCode = suspensionCode;
    this.name = string;
  }


  public int getStateCode() {
    return stateCode;
  }

  override
  public size_t toHash() {
    size_t prime = 31;
    size_t result = 1;
    result = prime * result + stateCode;
    return result;
  }

  override
  public bool opEquals(Object obj) {
    if (this == obj)
      return true;
    if (obj is null)
      return false;
    SuspensionStateImpl other = cast(SuspensionStateImpl) obj;
    if (other is null)
      return false;
    return stateCode == other.stateCode;
  }

  override
  public string toString() {
    return name;
  }
}

static SuspensionState  ACTIVE() {
  __gshared SuspensionState  inst;
  return initOnce!inst(new SuspensionStateImpl(1 , "active"));
}

static SuspensionState  SUSPENDED() {
  __gshared SuspensionState  inst;
  return initOnce!inst(new SuspensionStateImpl(2 , "suspended"));
}
