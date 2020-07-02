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
module flow.job.service.impl.JobProcessorContextImpl;

import flow.job.service.JobProcessor;
import flow.job.service.JobProcessorContext;
import flow.job.service.impl.persistence.entity.AbstractJobEntity;

/**
 * The default {@link JobProcessorContext} implementation used in the {@link JobProcessor}.
 *
 * @author Guy Brand
 * @see JobProcessor
 */
class JobProcessorContextImpl : JobProcessorContext {

    protected  Phase phase;
    protected  AbstractJobEntity jobEntity;

    this(Phase phase, AbstractJobEntity jobEntity) {
        this.phase = phase;
        this.jobEntity = jobEntity;
    }


    public Phase getPhase() {
        return phase;
    }


    public AbstractJobEntity getJobEntity() {
        return jobEntity;
    }


    public bool isInPhase(Phase phase) {
        return this.phase == (phase);
    }

    override
    public string toString() {
        return "JobProcessorContextImpl{" ;
                //"phase=" ~ phase ~
                //", jobEntity=" ~ jobEntity ~
                //'}';
    }

}
