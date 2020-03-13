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
module flow.batch.service.api.BatchPart;

import hunt.time.LocalDateTime;

alias Date  = LocalDateTime ;

interface BatchPart {

    string getId();

    string getBatchType();

    string getBatchId();

    Date getCreateTime();

    Date getCompleteTime();

    bool isCompleted();

    string getBatchSearchKey();

    string getBatchSearchKey2();

    string getStatus();

    string getScopeId();

    string getScopeType();

    string getSubScopeId();

    string getResultDocumentJson();

    string getTenantId();
}
