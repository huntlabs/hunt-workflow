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
module flow.job.service.impl.persistence.entity.DeadLetterJobEntityImpl;

import flow.common.persistence.entity.Entity;
import hunt.time.LocalDateTime;
import flow.job.service.impl.persistence.entity.JobByteArrayRef;
import  flow.job.service.impl.persistence.entity.AbstractJobEntityImpl;
import  flow.job.service.impl.persistence.entity.DeadLetterJobEntity;
/**
 * DeadLetterJob entity, necessary for persistence.
 *
 * @author Tijs Rademakers
 */
class DeadLetterJobEntityImpl : AbstractJobEntityImpl , DeadLetterJobEntity {

    override
    void setRetries(int retries)
    {
        super.setRetries(retries);
    }

    override
    void setJobHandlerType(string jobHandlerType)
    {
        super.setJobHandlerType(jobHandlerType);
    }

    override
    void setJobHandlerConfiguration(string jobHandlerConfiguration)
    {
        super.setJobHandlerConfiguration(jobHandlerConfiguration);
    }

    override
     string getCustomValues()
     {
          return super.getCustomValues;
     }

    override
    void setCustomValues(string customValues)
    {
        super.setCustomValues(customValues);
    }


    override
     JobByteArrayRef getCustomValuesByteArrayRef()
     {
          return super.getCustomValuesByteArrayRef;
     }


    override
    string getExceptionStacktrace()
    {
        return super.getExceptionStacktrace;
    }

    override
    void setExceptionStacktrace(string exception)
    {
        super.setExceptionStacktrace(exception);
    }

    override
     void setExceptionMessage(string exceptionMessage)
     {
          super.setExceptionMessage(exceptionMessage);
     }

    override
    JobByteArrayRef getExceptionByteArrayRef()
    {
        return super.getExceptionByteArrayRef;
    }


    override
    void setTenantId(string tenantId)
    {
        super.setTenantId(tenantId);
    }


    override
     LocalDateTime getCreateTime()
     {
          return super.getCreateTime();
     }


    override
    void setRevision(int revision)
    {
        super.setRevision(revision);
    }

    override  int getRevision()
    {
        return super.getRevision();
    }

    override
    int getRevisionNext()
    {
        return super.getRevisionNext;
    }

    override
    public string toString() {
        return "DeadLetterJobEntity [id=" ~ id ~ "]";
    }

    override
    int opCmp(Entity o)
    {
      return super.opCmp(o);
    }
}
