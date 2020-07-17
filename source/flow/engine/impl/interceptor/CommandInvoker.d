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
module flow.engine.impl.interceptor.CommandInvoker;

import flow.common.agenda.Agenda;
import flow.common.context.Context;
import flow.common.interceptor.AbstractCommandInterceptor;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandConfig;
import flow.common.interceptor.CommandContext;
import flow.common.interceptor.CommandInterceptor;
import flow.engine.FlowableEngineAgenda;
import flow.engine.impl.agenda.AbstractOperation;
import flow.engine.impl.util.CommandContextUtil;
import  flow.engine.repository.DeploymentBuilder;
import hunt.Exceptions;
import  hunt.util.Runnable;
import flow.engine.impl.cmd.ValidateV5EntitiesCmd;
import flow.engine.impl.DeploymentQueryImpl;
import flow.engine.impl.cmd.ValidateExecutionRelatedEntityCountCfgCmd;
import flow.engine.impl.cmd.ValidateTaskRelatedEntityCountCfgCmd;
import flow.engine.impl.RepositoryServiceImpl;
import flow.engine.impl.cmd.DeployCmd;
import flow.engine.impl.cmd.GetNextIdBlockCmd;
import flow.engine.impl.ProcessDefinitionQueryImpl;
import flow.engine.impl.cmd.StartProcessInstanceCmd;
import flow.task.service.impl.TaskQueryImpl;
import flow.engine.impl.cmd.GetTaskVariablesCmd;
import flow.engine.impl.cmd.CompleteTaskCmd;
import flow.engine.impl.HistoricActivityInstanceQueryImpl;
import hunt.logging;
/**
 * @author Joram Barrez
 */
class CommandInvoker : AbstractCommandInterceptor {
    //SchemaOperationsProcessEngineBuild
    //ValidateV5EntitiesCmd
  // DeploymentQueryImpl
  //ValidateExecutionRelatedEntityCountCfgCmd
  //ValidateTaskRelatedEntityCountCfgCmd
  //RepositoryServiceImpl
  //DeployCmd
 //GetNextIdBlockCmd
  //GetProcessDefinitionInfoCmd
  //ProcessDefinitionQueryImpl
//StartProcessInstanceCmd
//TaskQueryImpl
  //GetTaskVariablesCmd
//CompleteTaskCmd
  //HistoricActivityInstanceQueryImpl
    //  Object execute(CommandConfig config, CommandAbstract command);
    public  Object execute(CommandConfig config, CommandAbstract command) {
        CommandContext commandContext = Context.getCommandContext();
        FlowableEngineAgenda agenda = CommandContextUtil.getAgenda(commandContext);
        if (cast(ValidateV5EntitiesCmd)command !is null)
        {
            auto cmd = cast(ValidateV5EntitiesCmd)command;
            if (commandContext.isReused() && !agenda.isEmpty()) {
              return cast(Object)(cmd.execute(commandContext)) ;
            } else {
              (cast(Agenda)agenda).planOperation(new class Runnable {

                public void run() {
                  commandContext.setResult(cast(Object)cmd.execute(commandContext));
                }
              });
              // Run loop for agenda
              executeOperations(commandContext);

              // At the end, call the execution tree change listeners.
              // TODO: optimization: only do this when the tree has actually changed (ie check dbSqlSession).
              if (!commandContext.isReused() && CommandContextUtil.hasInvolvedExecutions(commandContext)) {
                agenda.planExecuteInactiveBehaviorsOperation();
                executeOperations(commandContext);
              }
              return commandContext.getResult();
            }
        } else if (cast(DeploymentQueryImpl)command !is null)
        {
            auto cmd = cast(DeploymentQueryImpl)command;
            if (commandContext.isReused() && !agenda.isEmpty()) {
              return cast(Object)(cmd.execute(commandContext)) ;
            } else {
              (cast(Agenda)agenda).planOperation(new class Runnable {

                public void run() {
                  commandContext.setResult(cast(Object)cmd.execute(commandContext));
                }
              });
              // Run loop for agenda
              executeOperations(commandContext);

              // At the end, call the execution tree change listeners.
              // TODO: optimization: only do this when the tree has actually changed (ie check dbSqlSession).
              if (!commandContext.isReused() && CommandContextUtil.hasInvolvedExecutions(commandContext)) {
                agenda.planExecuteInactiveBehaviorsOperation();
                executeOperations(commandContext);
              }
              return commandContext.getResult();
            }
        } else if (cast(ValidateExecutionRelatedEntityCountCfgCmd)command !is null)
          {
              auto cmd = cast(ValidateExecutionRelatedEntityCountCfgCmd)command;
              if (commandContext.isReused() && !agenda.isEmpty()) {
                return cast(Object)(cmd.execute(commandContext)) ;
              } else {
                (cast(Agenda)agenda).planOperation(new class Runnable {

                  public void run() {
                    commandContext.setResult(cast(Object)cmd.execute(commandContext));
                  }
                });
                // Run loop for agenda
                executeOperations(commandContext);

                // At the end, call the execution tree change listeners.
                // TODO: optimization: only do this when the tree has actually changed (ie check dbSqlSession).
                if (!commandContext.isReused() && CommandContextUtil.hasInvolvedExecutions(commandContext)) {
                  agenda.planExecuteInactiveBehaviorsOperation();
                  executeOperations(commandContext);
                }
                return commandContext.getResult();
              }
          } else if (cast(ValidateTaskRelatedEntityCountCfgCmd)command !is null)
            {
                auto cmd = cast(ValidateTaskRelatedEntityCountCfgCmd)command;
                if (commandContext.isReused() && !agenda.isEmpty()) {
                  return cast(Object)(cmd.execute(commandContext)) ;
                } else {
                  (cast(Agenda)agenda).planOperation(new class Runnable {

                    public void run() {
                      commandContext.setResult(cast(Object)cmd.execute(commandContext));
                    }
                  });
                  // Run loop for agenda
                  executeOperations(commandContext);

                  // At the end, call the execution tree change listeners.
                  // TODO: optimization: only do this when the tree has actually changed (ie check dbSqlSession).
                  if (!commandContext.isReused() && CommandContextUtil.hasInvolvedExecutions(commandContext)) {
                    agenda.planExecuteInactiveBehaviorsOperation();
                    executeOperations(commandContext);
                  }
                  return commandContext.getResult();
                }
            } else if (cast(DeployCmd)command !is null)
            {
                auto cmd = cast(DeployCmd)command;
                if (commandContext.isReused() && !agenda.isEmpty()) {
                  return cast(Object)(cmd.execute(commandContext)) ;
                } else {
                  (cast(Agenda)agenda).planOperation(new class Runnable {

                    public void run() {
                      commandContext.setResult(cast(Object)cmd.execute(commandContext));
                    }
                  });
                  // Run loop for agenda
                  executeOperations(commandContext);

                  // At the end, call the execution tree change listeners.
                  // TODO: optimization: only do this when the tree has actually changed (ie check dbSqlSession).
                  if (!commandContext.isReused() && CommandContextUtil.hasInvolvedExecutions(commandContext)) {
                    agenda.planExecuteInactiveBehaviorsOperation();
                    executeOperations(commandContext);
                  }
                return commandContext.getResult();
              }
            } else if (cast(GetNextIdBlockCmd)command !is null)
            {
                auto cmd = cast(GetNextIdBlockCmd)command;
                if (commandContext.isReused() && !agenda.isEmpty()) {
                  return cast(Object)(cmd.execute(commandContext)) ;
                } else {
                  (cast(Agenda)agenda).planOperation(new class Runnable {

                    public void run() {
                      commandContext.setResult(cast(Object)cmd.execute(commandContext));
                    }
                  });
                  // Run loop for agenda
                  executeOperations(commandContext);

                  // At the end, call the execution tree change listeners.
                  // TODO: optimization: only do this when the tree has actually changed (ie check dbSqlSession).
                  if (!commandContext.isReused() && CommandContextUtil.hasInvolvedExecutions(commandContext)) {
                    agenda.planExecuteInactiveBehaviorsOperation();
                    executeOperations(commandContext);
                  }
                  return commandContext.getResult();
                }
            }else if (cast(ProcessDefinitionQueryImpl)command !is null)
            {
                auto cmd = cast(ProcessDefinitionQueryImpl)command;
                if (commandContext.isReused() && !agenda.isEmpty()) {
                  return cast(Object)(cmd.execute(commandContext)) ;
                } else {
                  (cast(Agenda)agenda).planOperation(new class Runnable {

                    public void run() {
                      commandContext.setResult(cast(Object)cmd.execute(commandContext));
                    }
                  });
                  // Run loop for agenda
                  executeOperations(commandContext);

                  // At the end, call the execution tree change listeners.
                  // TODO: optimization: only do this when the tree has actually changed (ie check dbSqlSession).
                  if (!commandContext.isReused() && CommandContextUtil.hasInvolvedExecutions(commandContext)) {
                    agenda.planExecuteInactiveBehaviorsOperation();
                    executeOperations(commandContext);
                  }
                  return commandContext.getResult();
                }
            } else if (cast(StartProcessInstanceCmd)command !is null)
            {
                auto cmd = cast(StartProcessInstanceCmd)command;
                if (commandContext.isReused() && !agenda.isEmpty()) {
                  return cast(Object)(cmd.execute(commandContext)) ;
                } else {
                  (cast(Agenda)agenda).planOperation(new class Runnable {

                    public void run() {
                      commandContext.setResult(cast(Object)cmd.execute(commandContext));
                    }
                  });
                  // Run loop for agenda
                  executeOperations(commandContext);

                  // At the end, call the execution tree change listeners.
                  // TODO: optimization: only do this when the tree has actually changed (ie check dbSqlSession).
                  if (!commandContext.isReused() && CommandContextUtil.hasInvolvedExecutions(commandContext)) {
                    agenda.planExecuteInactiveBehaviorsOperation();
                    executeOperations(commandContext);
                  }
                  return commandContext.getResult();
                }
            } else if (cast(TaskQueryImpl)command !is null)
            {
              auto cmd = cast(TaskQueryImpl)command;
              if (commandContext.isReused() && !agenda.isEmpty()) {
                return cast(Object)(cmd.execute(commandContext)) ;
              } else {
                (cast(Agenda)agenda).planOperation(new class Runnable {

                  public void run() {
                    commandContext.setResult(cast(Object)cmd.execute(commandContext));
                  }
                });
                // Run loop for agenda
                executeOperations(commandContext);

                // At the end, call the execution tree change listeners.
                // TODO: optimization: only do this when the tree has actually changed (ie check dbSqlSession).
                if (!commandContext.isReused() && CommandContextUtil.hasInvolvedExecutions(commandContext)) {
                  agenda.planExecuteInactiveBehaviorsOperation();
                  executeOperations(commandContext);
                }
                return commandContext.getResult();
              }
            } else if(cast(GetTaskVariablesCmd)command !is null)
            {
                auto cmd = cast(GetTaskVariablesCmd)command;
                if (commandContext.isReused() && !agenda.isEmpty()) {
                  return cast(Object)(cmd.execute(commandContext)) ;
                } else {
                  (cast(Agenda)agenda).planOperation(new class Runnable {

                    public void run() {
                      commandContext.setResult(cast(Object)cmd.execute(commandContext));
                    }
                  });
                  // Run loop for agenda
                  executeOperations(commandContext);

                  // At the end, call the execution tree change listeners.
                  // TODO: optimization: only do this when the tree has actually changed (ie check dbSqlSession).
                  if (!commandContext.isReused() && CommandContextUtil.hasInvolvedExecutions(commandContext)) {
                    agenda.planExecuteInactiveBehaviorsOperation();
                    executeOperations(commandContext);
                  }
                  return commandContext.getResult();
                }
            }else if (cast(CompleteTaskCmd)command !is null)
            {
                auto cmd = cast(CompleteTaskCmd)command;
                if (commandContext.isReused() && !agenda.isEmpty()) {
                  return cast(Object)(cmd.execute(commandContext)) ;
                } else {
                  (cast(Agenda)agenda).planOperation(new class Runnable {

                    public void run() {
                      commandContext.setResult(cast(Object)cmd.execute(commandContext));
                    }
                  });
                  // Run loop for agenda
                  executeOperations(commandContext);

                  // At the end, call the execution tree change listeners.
                  // TODO: optimization: only do this when the tree has actually changed (ie check dbSqlSession).
                  if (!commandContext.isReused() && CommandContextUtil.hasInvolvedExecutions(commandContext)) {
                    agenda.planExecuteInactiveBehaviorsOperation();
                    executeOperations(commandContext);
                  }
                  return commandContext.getResult();
                }
            } else if(cast(HistoricActivityInstanceQueryImpl)command !is null)
            {
              auto cmd = cast(HistoricActivityInstanceQueryImpl)command;
              if (commandContext.isReused() && !agenda.isEmpty()) {
                return cast(Object)(cmd.execute(commandContext)) ;
              } else {
                (cast(Agenda)agenda).planOperation(new class Runnable {

                  public void run() {
                    commandContext.setResult(cast(Object)cmd.execute(commandContext));
                  }
                });
                // Run loop for agenda
                executeOperations(commandContext);

                // At the end, call the execution tree change listeners.
                // TODO: optimization: only do this when the tree has actually changed (ie check dbSqlSession).
                if (!commandContext.isReused() && CommandContextUtil.hasInvolvedExecutions(commandContext)) {
                  agenda.planExecuteInactiveBehaviorsOperation();
                  executeOperations(commandContext);
                }
                return commandContext.getResult();
              }
            }else if (cast(Command!DeploymentBuilder)command !is null)
            {
               auto cmd = cast(Command!DeploymentBuilder)command;
               if (commandContext.isReused() && !agenda.isEmpty()) {
                 return cast(Object)(cmd.execute(commandContext)) ;
               } else {
                 (cast(Agenda)agenda).planOperation( new class Runnable {

                   public void run() {
                     commandContext.setResult( cast(Object)cmd.execute( commandContext));
                   }
                 });
                 // Run loop for agenda
                 executeOperations( commandContext);

                 // At the end, call the execution tree change listeners.
                 // TODO: optimization: only do this when the tree has actually changed (ie check dbSqlSession).
                 if (!commandContext.isReused() && CommandContextUtil.hasInvolvedExecutions( commandContext)) {
                   agenda.planExecuteInactiveBehaviorsOperation();
                   executeOperations( commandContext);
                 }
                 return commandContext.getResult();
               }
            }
            else
            {
                logInfo("type: %s" , typeid(command).toString);
                implementationMissing(false);
                return null;
            }


    }

    protected void executeOperations(CommandContext commandContext) {
        while (!CommandContextUtil.getAgenda(commandContext).isEmpty()) {
            Runnable runnable = CommandContextUtil.getAgenda(commandContext).getNextOperation();
            executeOperation(runnable);
        }
    }

    public void executeOperation(Runnable runnable) {
        if (cast(AbstractOperation)runnable !is null) {
            AbstractOperation operation = cast(AbstractOperation) runnable;

            // Execute the operation if the operation has no execution (i.e. it's an operation not working on a process instance)
            // or the operation has an execution and it is not ended
            if (operation.getExecution() is null || !operation.getExecution().isEnded()) {

                //if (LOGGER.isDebugEnabled()) {
                //    LOGGER.debug("Executing operation {}", operation.getClass());
                //}

                runnable.run();

            }

        } else {
            runnable.run();
        }
    }

    override
    public CommandInterceptor getNext() {
        return null;
    }

    override
    public void setNext(CommandInterceptor next) {
        throw new UnsupportedOperationException("CommandInvoker must be the last interceptor in the chain");
    }

}
