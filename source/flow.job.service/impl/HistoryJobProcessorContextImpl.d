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
module flow.job.service.impl.HistoryJobProcessorContextImpl;

import flow.job.service.HistoryJobProcessor;
import flow.job.service.HistoryJobProcessorContext;
import flow.job.service.impl.persistence.entity.HistoryJobEntity;

/**
 * The default {@link HistoryJobProcessorContext} implementation used in the {@link HistoryJobProcessor}.
 *
 * @author Guy Brand
 * @see HistoryJobProcessor
 */
class HistoryJobProcessorContextImpl : HistoryJobProcessorContext {

    protected  Phase phase;
    protected  HistoryJobEntity historyJobEntity;

    this(Phase phase, HistoryJobEntity historyJobEntity) {
        this.phase = phase;
        this.historyJobEntity = historyJobEntity;
    }


    public Phase getPhase() {
        return phase;
    }


    public HistoryJobEntity getHistoryJobEntity() {
        return historyJobEntity;
    }


    public bool isInPhase(Phase phase) {
        return this.phase.equals(phase);
    }

    override
    public string toString() {
        return "HistoryJobProcessorContextImpl{";
                //"phase=" + phase +
                //", historyJobEntity=" + historyJobEntity +
                //'}';
    }

}
