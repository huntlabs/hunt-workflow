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


/**
 * @author Tijs Rademakers
 */
class AdhocSubProcess extends SubProcess {

    public static final string ORDERING_PARALLEL = "Parallel";
    public static final string ORDERING_SEQUENTIALL = "Sequential";

    protected string completionCondition;
    protected string ordering = ORDERING_PARALLEL;
    protected boolean cancelRemainingInstances = true;

    public string getCompletionCondition() {
        return completionCondition;
    }

    public void setCompletionCondition(string completionCondition) {
        this.completionCondition = completionCondition;
    }

    public string getOrdering() {
        return ordering;
    }

    public void setOrdering(string ordering) {
        this.ordering = ordering;
    }

    public boolean hasParallelOrdering() {
        return !ORDERING_SEQUENTIALL.equals(ordering);
    }

    public boolean hasSequentialOrdering() {
        return ORDERING_SEQUENTIALL.equals(ordering);
    }

    public boolean isCancelRemainingInstances() {
        return cancelRemainingInstances;
    }

    public void setCancelRemainingInstances(boolean cancelRemainingInstances) {
        this.cancelRemainingInstances = cancelRemainingInstances;
    }
}
