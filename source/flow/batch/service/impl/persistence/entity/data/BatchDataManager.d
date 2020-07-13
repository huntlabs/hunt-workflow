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
module flow.batch.service.impl.persistence.entity.data.BatchDataManager;

import hunt.collection.List;

import flow.batch.service.api.Batch;
import flow.batch.service.impl.BatchQueryImpl;
import flow.batch.service.impl.persistence.entity.BatchEntity;
import flow.common.persistence.entity.data.DataManager;

interface BatchDataManager : DataManager!BatchEntity {

    List!Batch findBatchesBySearchKey(string searchKey);

    List!Batch findAllBatches();

    List!Batch findBatchesByQueryCriteria(BatchQueryImpl batchQuery);

    long findBatchCountByQueryCriteria(BatchQueryImpl batchQuery);
}
