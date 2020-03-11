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

module flow.engine.history.DeleteReason;

/**
 * @author Joram Barrez
 */
interface DeleteReason {

    string PROCESS_INSTANCE_DELETED = "process instance deleted";

    string TERMINATE_END_EVENT = "terminate end event";

    string BOUNDARY_EVENT_INTERRUPTING = "boundary event";

    string EVENT_SUBPROCESS_INTERRUPTING = "event subprocess";

    string EVENT_BASED_GATEWAY_CANCEL = "event based gateway cancel";

    string TRANSACTION_CANCELED = "transaction canceled";

}
