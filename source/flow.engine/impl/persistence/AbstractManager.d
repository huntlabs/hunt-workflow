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



import flow.common.api.deleg.event.FlowableEventDispatcher;
import flow.common.context.Context;
import flow.common.interceptor.CommandContext;
import flow.common.interceptor.CommandExecutor;
import flow.common.runtime.Clock;
import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
import flow.engine.impl.history.HistoryManager;
import flow.engine.impl.persistence.entity.ActivityInstanceEntityManager;
import flow.engine.impl.persistence.entity.AttachmentEntityManager;
import flow.engine.impl.persistence.entity.ByteArrayEntityManager;
import flow.engine.impl.persistence.entity.CommentEntityManager;
import flow.engine.impl.persistence.entity.DeploymentEntityManager;
import flow.engine.impl.persistence.entity.ExecutionEntityManager;
import flow.engine.impl.persistence.entity.HistoricActivityInstanceEntityManager;
import flow.engine.impl.persistence.entity.HistoricDetailEntityManager;
import flow.engine.impl.persistence.entity.HistoricProcessInstanceEntityManager;
import flow.engine.impl.persistence.entity.ModelEntityManager;
import flow.engine.impl.persistence.entity.ProcessDefinitionEntityManager;
import flow.engine.impl.persistence.entity.ProcessDefinitionInfoEntityManager;
import flow.engine.impl.persistence.entity.ResourceEntityManager;
import org.flowable.job.service.impl.asyncexecutor.AsyncExecutor;

/**
 * @author Tom Baeyens
 * @author Joram Barrez
 */
abstract class AbstractManager {

    protected ProcessEngineConfigurationImpl processEngineConfiguration;

    public AbstractManager(ProcessEngineConfigurationImpl processEngineConfiguration) {
        this.processEngineConfiguration = processEngineConfiguration;
    }

    // Command scoped

    protected CommandContext getCommandContext() {
        return Context.getCommandContext();
    }

    protected <T> T getSession(Class<T> sessionClass) {
        return getCommandContext().getSession(sessionClass);
    }

    // Engine scoped

    protected ProcessEngineConfigurationImpl getProcessEngineConfiguration() {
        return processEngineConfiguration;
    }

    protected CommandExecutor getCommandExecutor() {
        return getProcessEngineConfiguration().getCommandExecutor();
    }

    protected Clock getClock() {
        return getProcessEngineConfiguration().getClock();
    }

    protected AsyncExecutor getAsyncExecutor() {
        return getProcessEngineConfiguration().getAsyncExecutor();
    }

    protected FlowableEventDispatcher getEventDispatcher() {
        return getProcessEngineConfiguration().getEventDispatcher();
    }

    protected HistoryManager getHistoryManager() {
        return getProcessEngineConfiguration().getHistoryManager();
    }

    protected DeploymentEntityManager getDeploymentEntityManager() {
        return getProcessEngineConfiguration().getDeploymentEntityManager();
    }

    protected ResourceEntityManager getResourceEntityManager() {
        return getProcessEngineConfiguration().getResourceEntityManager();
    }

    protected ByteArrayEntityManager getByteArrayEntityManager() {
        return getProcessEngineConfiguration().getByteArrayEntityManager();
    }

    protected ProcessDefinitionEntityManager getProcessDefinitionEntityManager() {
        return getProcessEngineConfiguration().getProcessDefinitionEntityManager();
    }

    protected ProcessDefinitionInfoEntityManager getProcessDefinitionInfoEntityManager() {
        return getProcessEngineConfiguration().getProcessDefinitionInfoEntityManager();
    }

    protected ModelEntityManager getModelEntityManager() {
        return getProcessEngineConfiguration().getModelEntityManager();
    }

    protected ExecutionEntityManager getExecutionEntityManager() {
        return getProcessEngineConfiguration().getExecutionEntityManager();
    }

    protected ActivityInstanceEntityManager getActivityInstanceEntityManager() {
        return getProcessEngineConfiguration().getActivityInstanceEntityManager();
    }

    protected HistoricProcessInstanceEntityManager getHistoricProcessInstanceEntityManager() {
        return getProcessEngineConfiguration().getHistoricProcessInstanceEntityManager();
    }

    protected HistoricDetailEntityManager getHistoricDetailEntityManager() {
        return getProcessEngineConfiguration().getHistoricDetailEntityManager();
    }

    protected HistoricActivityInstanceEntityManager getHistoricActivityInstanceEntityManager() {
        return getProcessEngineConfiguration().getHistoricActivityInstanceEntityManager();
    }

    protected AttachmentEntityManager getAttachmentEntityManager() {
        return getProcessEngineConfiguration().getAttachmentEntityManager();
    }

    protected CommentEntityManager getCommentEntityManager() {
        return getProcessEngineConfiguration().getCommentEntityManager();
    }
}
