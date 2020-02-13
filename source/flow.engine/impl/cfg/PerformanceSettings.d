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
 * @author Joram Barrez
 */
class PerformanceSettings {

    /**
     * If true, whenever an execution is fetched from the data store, the whole execution tree is fetched in the same roundtrip.
     * 
     * Less roundtrips to the database outweighs doing many, smaller fetches and often multiple executions from the same tree are 
     * needed anyway when executing process instances.
     * 
     * This enables the setting globally. However, it must also be enabled on a process definition itself.
     * If false, the setting on the process definition is ignored.
     */
    protected bool enableEagerExecutionTreeFetching = false;

    /**
     * Keeps a count on each execution that holds how many variables, jobs, tasks, event subscriptions, etc. the execution has.
     * 
     * This makes the delete more performant as a query is not needed anymore to check if there is related data. 
     * However, maintaining the count does mean more updates to the execution and potentially
     * more optimistic locking opportunities. 
     * Typically keeping the counts lead to better performance as deletes are a large part of the execution tree maintenance.
     *
     * This property can only be enabled or disabled globally currently.
     */
    protected bool enableExecutionRelationshipCounts = true;

    /**
     * Similar to <code>enableExecutionRelationshipCounts</code>, but on the task level. Keeps count of how many variables ad identity links the task has.
     */
    protected bool enableTaskRelationshipCounts = true;

    /**
     * If false, no check will be done on boot.
     */
    protected bool validateExecutionRelationshipCountConfigOnBoot = true;

    /**
     * If false, no check will be done on boot.
     */
    protected bool validateTaskRelationshipCountConfigOnBoot = true;

    /**
     * Experimental setting: in certain places in the engine (execution/process instance/historic process instance/ tasks/data objects) localization is supported. When this setting is false,
     * localization is completely disabled, which gives a small performance gain.
     */
    protected bool enableLocalization = true;

    public bool isEnableEagerExecutionTreeFetching() {
        return enableEagerExecutionTreeFetching;
    }

    public void setEnableEagerExecutionTreeFetching(bool enableEagerExecutionTreeFetching) {
        this.enableEagerExecutionTreeFetching = enableEagerExecutionTreeFetching;
    }

    public bool isEnableExecutionRelationshipCounts() {
        return enableExecutionRelationshipCounts;
    }

    public void setEnableExecutionRelationshipCounts(bool enableExecutionRelationshipCounts) {
        this.enableExecutionRelationshipCounts = enableExecutionRelationshipCounts;
    }

    public bool isEnableTaskRelationshipCounts() {
        return enableTaskRelationshipCounts;
    }

    public void setEnableTaskRelationshipCounts(bool enableTaskRelationshipCounts) {
        this.enableTaskRelationshipCounts = enableTaskRelationshipCounts;
    }

    public bool isValidateExecutionRelationshipCountConfigOnBoot() {
        return validateExecutionRelationshipCountConfigOnBoot;
    }

    public void setValidateExecutionRelationshipCountConfigOnBoot(bool validateExecutionRelationshipCountConfigOnBoot) {
        this.validateExecutionRelationshipCountConfigOnBoot = validateExecutionRelationshipCountConfigOnBoot;
    }

    public bool isValidateTaskRelationshipCountConfigOnBoot() {
        return validateTaskRelationshipCountConfigOnBoot;
    }

    public void setValidateTaskRelationshipCountConfigOnBoot(bool validateTaskRelationshipCountConfigOnBoot) {
        this.validateTaskRelationshipCountConfigOnBoot = validateTaskRelationshipCountConfigOnBoot;
    }

    public bool isEnableLocalization() {
        return enableLocalization;
    }

    public void setEnableLocalization(bool enableLocalization) {
        this.enableLocalization = enableLocalization;
    }

}
