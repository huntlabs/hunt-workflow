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


import java.util.Date;

import flow.common.db.HasRevision;
import flow.common.persistence.entity.Entity;

/**
 * @author Tijs Rademakers
 * @author Joram Barrez
 */
interface AbstractJobEntity extends Entity, HasRevision {

    void setRetries(int retries);

    void setJobHandlerType(string jobHandlerType);

    void setJobHandlerConfiguration(string jobHandlerConfiguration);

    string getCustomValues();

    void setCustomValues(string customValues);

    JobByteArrayRef getCustomValuesByteArrayRef();

    string getExceptionStacktrace();

    void setExceptionStacktrace(string exception);

    void setExceptionMessage(string exceptionMessage);

    JobByteArrayRef getExceptionByteArrayRef();

    void setTenantId(string tenantId);

    Date getCreateTime();

}
