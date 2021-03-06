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
module flow.engine.impl.DefaultProcessJobParentStateResolver;

import flow.common.api.FlowableIllegalArgumentException;
import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
import flow.engine.runtime.ProcessInstance;
import flow.job.service.api.Job;
import flow.job.service.InternalJobParentStateResolver;

/**
 * @author martin.grofcik
 */
class DefaultProcessJobParentStateResolver : InternalJobParentStateResolver {
    protected ProcessEngineConfigurationImpl processEngineConfiguration;

    this(ProcessEngineConfigurationImpl processEngineConfiguration) {
        this.processEngineConfiguration = processEngineConfiguration;
    }

    public bool isSuspended(Job job) {
        if (job.getProcessInstanceId() is null || job.getProcessInstanceId().length == 0) {
            throw new FlowableIllegalArgumentException("Job " ~ job.getId() ~ " parent is not process instance");
        }
        ProcessInstance processInstance = this.processEngineConfiguration.getRuntimeService().createProcessInstanceQuery().processInstanceId(job.getProcessInstanceId()).singleResult();
        return processInstance.isSuspended();
    }
}
