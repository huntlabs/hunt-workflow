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
module flow.engine.impl.bpmn.parser.factory.DefaultListenerFactory;

import hunt.collection.HashMap;
import hunt.collection.Map;

import flow.bpmn.model.EventListener;
import flow.bpmn.model.FlowableListener;
import flow.bpmn.model.ImplementationType;
import flow.common.api.FlowableIllegalArgumentException;
import flow.common.api.deleg.event.FlowableEventListener;
import flow.engine.deleg.CustomPropertiesResolver;
import flow.engine.deleg.ExecutionListener;
import flow.engine.deleg.TransactionDependentTaskListener;
import flow.engine.impl.bpmn.helper.BaseDelegateEventListener;
import flow.engine.impl.bpmn.helper.ClassDelegateFactory;
import flow.engine.impl.bpmn.helper.DefaultClassDelegateFactory;
import flow.engine.impl.bpmn.helper.DelegateExpressionFlowableEventListener;
import flow.engine.impl.bpmn.helper.DelegateFlowableEventListener;
import flow.engine.impl.bpmn.helper.ErrorThrowingEventListener;
import flow.engine.impl.bpmn.helper.MessageThrowingEventListener;
import flow.engine.impl.bpmn.helper.SignalThrowingEventListener;
import flow.engine.impl.bpmn.listener.DelegateExpressionCustomPropertiesResolver;
import flow.engine.impl.bpmn.listener.DelegateExpressionExecutionListener;
import flow.engine.impl.bpmn.listener.DelegateExpressionTaskListener;
import flow.engine.impl.bpmn.listener.DelegateExpressionTransactionDependentExecutionListener;
import flow.engine.impl.bpmn.listener.DelegateExpressionTransactionDependentTaskListener;
import flow.engine.impl.bpmn.listener.ExpressionCustomPropertiesResolver;
import flow.engine.impl.bpmn.listener.ExpressionExecutionListener;
import flow.engine.impl.bpmn.listener.ExpressionTaskListener;
import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
import flow.engine.repository.ProcessDefinition;
import flow.engine.runtime.Execution;
import flow.engine.runtime.ProcessInstance;
import flow.engine.task.Attachment;
import flow.engine.task.Comment;
import flow.identitylink.api.IdentityLink;
import flow.job.service.api.Job;
import flow.task.api.Task;
import flow.task.service.deleg.TaskListener;
import flow.engine.impl.bpmn.parser.factory.AbstractBehaviorFactory;
import flow.engine.impl.bpmn.parser.factory.ListenerFactory;
import std.concurrency : initOnce;
import std.string;
import hunt.collection.List;
import hunt.collection.ArrayList;
import flow.engine.impl.persistence.entity.data.impl.MybatisProcessDefinitionDataManager;
import flow.engine.impl.persistence.entity.data.impl.MybatisExecutionDataManager;
import flow.engine.impl.persistence.entity.data.impl.MybatisDeploymentDataManager;
import flow.engine.impl.persistence.entity.data.impl.MybatisResourceDataManager;
import flow.engine.impl.persistence.entity.data.impl.MybatisHistoricProcessInstanceDataManager;
import flow.engine.impl.persistence.entity.data.impl.MybatisActivityInstanceDataManager;
import flow.engine.impl.persistence.entity.data.impl.MybatisHistoricActivityInstanceDataManager;
import flow.task.service.impl.persistence.entity.data.impl.MybatisTaskDataManager;
import flow.task.service.impl.persistence.entity.data.impl.MybatisHistoricTaskInstanceDataManager;
import flow.identitylink.service.impl.persistence.entity.data.impl.MybatisIdentityLinkDataManager;
import flow.identitylink.service.impl.persistence.entity.data.impl.MybatisHistoricIdentityLinkDataManager;
import flow.variable.service.impl.persistence.entity.data.impl.MybatisVariableInstanceDataManager;
import flow.variable.service.impl.persistence.entity.data.impl.MybatisHistoricVariableInstanceDataManager;
import flow.common.persistence.entity.data.impl.MybatisPropertyDataManager;
import flow.engine.impl.persistence.entity.data.impl.MybatisByteArrayDataManager;
/**
 * Default implementation of the {@link ListenerFactory}. Used when no custom {@link ListenerFactory} is injected on the {@link ProcessEngineConfigurationImpl}.
 *
 * @author Joram Barrez
 */
static List!TypeInfo insertOrder;
static List!TypeInfo deleteOrder;

class DefaultListenerFactory : AbstractBehaviorFactory , ListenerFactory {
    private ClassDelegateFactory classDelegateFactory;

    this(ClassDelegateFactory classDelegateFactory) {
        this.classDelegateFactory = classDelegateFactory;
    }

    this() {
        this(new DefaultClassDelegateFactory());
    }

    static Map!(string,TypeInfo) ENTITY_MAPPING() {
      __gshared Map!(string,TypeInfo) inst;
      return initOnce!inst(new HashMap!(string,TypeInfo));
    }

   // public static final Map<string, Class<?>> ENTITY_MAPPING = new HashMap<>();
  shared static  this() {
        ENTITY_MAPPING.put("attachment", typeid(Attachment));
        ENTITY_MAPPING.put("comment", typeid(Comment));
        ENTITY_MAPPING.put("execution", typeid(Execution));
        ENTITY_MAPPING.put("identity-link", typeid(IdentityLink));
        ENTITY_MAPPING.put("job", typeid(Job));
        ENTITY_MAPPING.put("process-definition", typeid(ProcessDefinition));
        ENTITY_MAPPING.put("process-instance", typeid(ProcessInstance));
        ENTITY_MAPPING.put("task", typeid(Task));

        if (insertOrder is null)
        {
          insertOrder = new ArrayList!TypeInfo;
          insertOrder.add(typeid(MybatisHistoricVariableInstanceDataManager)); //4
          insertOrder.add(typeid(MybatisHistoricTaskInstanceDataManager)); //6
          insertOrder.add(typeid(MybatisHistoricProcessInstanceDataManager)); //7
          insertOrder.add(typeid(MybatisHistoricActivityInstanceDataManager));//8
          insertOrder.add(typeid(MybatisHistoricIdentityLinkDataManager));//9
          insertOrder.add(typeid(MybatisProcessDefinitionDataManager));//11
          insertOrder.add(typeid(MybatisExecutionDataManager));//12
          insertOrder.add(typeid(MybatisActivityInstanceDataManager));//13
          insertOrder.add(typeid(MybatisTaskDataManager)); //14
          insertOrder.add(typeid(MybatisIdentityLinkDataManager));//15
          insertOrder.add(typeid(MybatisDeploymentDataManager));//25
          insertOrder.add(typeid(MybatisResourceDataManager));//26
          insertOrder.add(typeid(MybatisByteArrayDataManager));//30
          insertOrder.add(typeid(MybatisVariableInstanceDataManager));//32
          insertOrder.add(typeid(MybatisPropertyDataManager));//44
        }

        if(deleteOrder is null)
        {
            deleteOrder = new ArrayList!TypeInfo;
            deleteOrder.add(typeid(MybatisPropertyDataManager));//0
            deleteOrder.add(typeid(MybatisVariableInstanceDataManager));//12
            deleteOrder.add(typeid(MybatisByteArrayDataManager));//14
            deleteOrder.add(typeid(MybatisResourceDataManager));//18
            deleteOrder.add(typeid(MybatisDeploymentDataManager));//19
            deleteOrder.add(typeid(MybatisIdentityLinkDataManager));//29
            deleteOrder.add(typeid(MybatisTaskDataManager));//30
            deleteOrder.add(typeid(MybatisActivityInstanceDataManager));//31
            deleteOrder.add(typeid(MybatisExecutionDataManager));//32
            deleteOrder.add(typeid(MybatisHistoricIdentityLinkDataManager));//35
            deleteOrder.add(typeid(MybatisHistoricActivityInstanceDataManager));//36
            deleteOrder.add(typeid(MybatisHistoricProcessInstanceDataManager));//37
            deleteOrder.add(typeid(MybatisHistoricTaskInstanceDataManager));//38
            deleteOrder.add(typeid(MybatisHistoricVariableInstanceDataManager));//40
        }
    }


    public TaskListener createClassDelegateTaskListener(FlowableListener listener) {
        return classDelegateFactory.create(listener.getImplementation(),
                createFieldDeclarations(listener.getFieldExtensions()));
    }


    public TaskListener createExpressionTaskListener(FlowableListener listener) {
        return new ExpressionTaskListener(expressionManager.createExpression(listener.getImplementation()));
    }


    public TaskListener createDelegateExpressionTaskListener(FlowableListener listener) {
        return new DelegateExpressionTaskListener(expressionManager.createExpression(listener.getImplementation()), createFieldDeclarations(listener.getFieldExtensions()));
    }


    public TransactionDependentTaskListener createTransactionDependentDelegateExpressionTaskListener(FlowableListener listener) {
        return new DelegateExpressionTransactionDependentTaskListener(expressionManager.createExpression(listener.getImplementation()));
    }


    public ExecutionListener createClassDelegateExecutionListener(FlowableListener listener) {
        return classDelegateFactory.create(listener.getImplementation(), createFieldDeclarations(listener.getFieldExtensions()));
    }


    public ExecutionListener createExpressionExecutionListener(FlowableListener listener) {
        return new ExpressionExecutionListener(expressionManager.createExpression(listener.getImplementation()));
    }


    public ExecutionListener createDelegateExpressionExecutionListener(FlowableListener listener) {
        return new DelegateExpressionExecutionListener(expressionManager.createExpression(listener.getImplementation()), createFieldDeclarations(listener.getFieldExtensions()));
    }


    public DelegateExpressionTransactionDependentExecutionListener createTransactionDependentDelegateExpressionExecutionListener(FlowableListener listener) {
        return new DelegateExpressionTransactionDependentExecutionListener(expressionManager.createExpression(listener.getImplementation()));
    }


    public FlowableEventListener createClassDelegateEventListener(EventListener eventListener) {
        return new DelegateFlowableEventListener(eventListener.getImplementation(), getEntityType(eventListener.getEntityType()));
    }


    public FlowableEventListener createDelegateExpressionEventListener(EventListener eventListener) {
        return new DelegateExpressionFlowableEventListener(expressionManager.createExpression(eventListener.getImplementation()), getEntityType(eventListener.getEntityType()));
    }


    public FlowableEventListener createEventThrowingEventListener(EventListener eventListener) {
        BaseDelegateEventListener result = null;
        if (ImplementationType.IMPLEMENTATION_TYPE_THROW_SIGNAL_EVENT == (eventListener.getImplementationType())) {
            result = new SignalThrowingEventListener();
            (cast(SignalThrowingEventListener) result).setSignalName(eventListener.getImplementation());
            (cast(SignalThrowingEventListener) result).setProcessInstanceScope(true);
        } else if (ImplementationType.IMPLEMENTATION_TYPE_THROW_GLOBAL_SIGNAL_EVENT == (eventListener.getImplementationType())) {
            result = new SignalThrowingEventListener();
            (cast(SignalThrowingEventListener) result).setSignalName(eventListener.getImplementation());
            (cast(SignalThrowingEventListener) result).setProcessInstanceScope(false);
        } else if (ImplementationType.IMPLEMENTATION_TYPE_THROW_MESSAGE_EVENT == (eventListener.getImplementationType())) {
            result = new MessageThrowingEventListener();
            (cast(MessageThrowingEventListener) result).setMessageName(eventListener.getImplementation());
        } else if (ImplementationType.IMPLEMENTATION_TYPE_THROW_ERROR_EVENT == (eventListener.getImplementationType())) {
            result = new ErrorThrowingEventListener();
            (cast(ErrorThrowingEventListener) result).setErrorCode(eventListener.getImplementation());
        }

        if (result is null) {
            throw new FlowableIllegalArgumentException("Cannot create an event-throwing event-listener, unknown implementation type: " ~ eventListener.getImplementationType());
        }

        result.setEntityClass(getEntityType(eventListener.getEntityType()));
        return result;
    }


    public CustomPropertiesResolver createClassDelegateCustomPropertiesResolver(FlowableListener listener) {
        return classDelegateFactory.create(listener.getCustomPropertiesResolverImplementation(), null);
    }


    public CustomPropertiesResolver createExpressionCustomPropertiesResolver(FlowableListener listener) {
        return new ExpressionCustomPropertiesResolver(expressionManager.createExpression(listener.getCustomPropertiesResolverImplementation()));
    }


    public CustomPropertiesResolver createDelegateExpressionCustomPropertiesResolver(FlowableListener listener) {
        return new DelegateExpressionCustomPropertiesResolver(expressionManager.createExpression(listener.getCustomPropertiesResolverImplementation()));
    }

    /**
     * @param entityType
     *            the name of the entity
     * @return
     * @throws FlowableIllegalArgumentException
     *             when the given entity name
     */
    protected TypeInfo getEntityType(string entityType) {
        if (entityType !is null) {
            TypeInfo entityClass = ENTITY_MAPPING.get(strip(entityType));
            if (entityClass is null) {
                throw new FlowableIllegalArgumentException("Unsupported entity-type for a FlowableEventListener: " ~ typeid(entityType).toString());
            }
            return entityClass;
        }
        return null;
    }
}
