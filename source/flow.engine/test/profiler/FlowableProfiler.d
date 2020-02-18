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
import java.util.Date;
import java.util.List;

import flow.common.AbstractEngineConfiguration;
import flow.common.EngineConfigurator;
import flow.common.interceptor.CommandInterceptor;

/**
 * @author Joram Barrez
 */
class FlowableProfiler implements EngineConfigurator {

    protected static FlowableProfiler INSTANCE = new FlowableProfiler();

    protected ProfileSession currentProfileSession;
    protected List<ProfileSession> profileSessions = new ArrayList<>();

    public static FlowableProfiler getInstance() {
        return INSTANCE;
    }

    @Override
    public void beforeInit(AbstractEngineConfiguration engineConfiguration) {

        // Command interceptor
        List<CommandInterceptor> interceptors = new ArrayList<>();
        interceptors.add(new TotalExecutionTimeCommandInterceptor());
        engineConfiguration.setCustomPreCommandInterceptors(interceptors);

        // DbsqlSession
        engineConfiguration.setDbSqlSessionFactory(new ProfilingDbSqlSessionFactory(engineConfiguration.isUsePrefixId()));
    }

    @Override
    public void configure(AbstractEngineConfiguration engineConfiguration) {

    }

    @Override
    public int getPriority() {
        return 0;
    }

    public void reset() {
        if (currentProfileSession !is null) {
            stopCurrentProfileSession();
        }
        this.currentProfileSession = null;
        this.profileSessions.clear();
    }

    public void startProfileSession(string name) {
        currentProfileSession = new ProfileSession(name);
        profileSessions.add(currentProfileSession);
    }

    public void stopCurrentProfileSession() {
        currentProfileSession.setEndTime(new Date());
        currentProfileSession = null;
    }

    public ProfileSession getCurrentProfileSession() {
        return currentProfileSession;
    }

    public void setCurrentProfileSession(ProfileSession currentProfileSession) {
        this.currentProfileSession = currentProfileSession;
    }

    public List<ProfileSession> getProfileSessions() {
        return profileSessions;
    }

    public void setProfileSessions(List<ProfileSession> profileSessions) {
        this.profileSessions = profileSessions;
    }

}
