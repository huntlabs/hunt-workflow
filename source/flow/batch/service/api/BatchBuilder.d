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
module flow.batch.service.api.BatchBuilder;

import flow.batch.service.api.Batch;
interface BatchBuilder {

    BatchBuilder batchType(string batchType);

    BatchBuilder searchKey(string searchKey);

    BatchBuilder searchKey2(string searchKey2);

    BatchBuilder status(string status);

    BatchBuilder batchDocumentJson(string batchDocumentJson);

    BatchBuilder tenantId(string tenantId);

    Batch create();

    string getBatchType();

    string getSearchKey();

    string getSearchKey2();

    string getStatus();

    string getBatchDocumentJson();

    string getTenantId();
}
