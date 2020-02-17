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


import java.util.ArrayList;
import java.util.List;

import flow.common.interceptor.CommandContext;
import flow.common.interceptor.Session;
import flow.common.interceptor.SessionFactory;

class AsyncHistorySessionFactory implements SessionFactory {

    protected AsyncHistoryListener asyncHistoryListener;
    protected List<string> registeredJobDataTypes = new ArrayList<>();

    @Override
    class<?> getSessionType() {
        return AsyncHistorySession.class;
    }

    @Override
    public Session openSession(CommandContext commandContext) {
        return new AsyncHistorySession(commandContext, asyncHistoryListener, registeredJobDataTypes);
    }
    
    public void registerJobDataTypes(List<string> registeredJobDataTypes) {
        this.registeredJobDataTypes.addAll(registeredJobDataTypes);
    }
    
    public AsyncHistoryListener getAsyncHistoryListener() {
        return asyncHistoryListener;
    }

    public void setAsyncHistoryListener(AsyncHistoryListener asyncHistoryListener) {
        this.asyncHistoryListener = asyncHistoryListener;
    }

    public List<string> getRegisteredJobDataTypes() {
        return registeredJobDataTypes;
    }

    public void setRegisteredJobDataTypes(List<string> registeredJobDataTypes) {
        this.registeredJobDataTypes = registeredJobDataTypes;
    }
    
}
