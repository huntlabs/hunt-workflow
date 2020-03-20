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
module flow.engine.DefaultHistoryCleaningManager;

//import java.util.Calendar;
//import java.util.GregorianCalendar;
import hunt.Exceptions;

import flow.engine.impl.HistoricProcessInstanceQueryImpl;
import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
import flow.engine.HistoryCleaningManager;

class DefaultHistoryCleaningManager : HistoryCleaningManager {

    protected ProcessEngineConfigurationImpl processEngineConfiguration;

    this(ProcessEngineConfigurationImpl processEngineConfiguration) {
        this.processEngineConfiguration = processEngineConfiguration;
    }

    public HistoricProcessInstanceQueryImpl createHistoricProcessInstanceCleaningQuery() {
        implementationMissing(false);
        return null;
        //int days = processEngineConfiguration.getCleanInstancesEndedAfterNumberOfDays();
        //Calendar cal = new GregorianCalendar();
        //cal.add(Calendar.DAY_OF_YEAR, -days);
        //HistoricProcessInstanceQueryImpl historicProcessInstanceQuery = new HistoricProcessInstanceQueryImpl(processEngineConfiguration.getCommandExecutor());
        //historicProcessInstanceQuery.finishedBefore(cal.getTime());
        //return historicProcessInstanceQuery;
    }
}
