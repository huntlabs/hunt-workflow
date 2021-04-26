module example.Test;

import flow.engine.ProcessEngineConfiguration;
import flow.engine.history.HistoricActivityInstance;
import flow.engine.impl.cfg.StandaloneProcessEngineConfiguration;
import flow.engine.repository.Deployment;
import flow.engine.repository.ProcessDefinition;
import flow.engine.runtime.ProcessInstance;
import flow.engine.ProcessEngine;
import flow.engine.RepositoryService;
import flow.engine.TaskService;
import flow.engine.RuntimeService;
import flow.task.api.Task;
import std.stdio;
import std.conv : to;
import hunt.Boolean;
import hunt.String;
import hunt.Integer;
import hunt.collection.HashMap;
import hunt.collection.List;
import hunt.collection.Map;
import std.array;
import std.string : strip;
import hunt.logging;

void main() {

    ProcessEngineConfiguration cfg = new StandaloneProcessEngineConfiguration()
    .setJdbcUrl("10.1.23.200:3306")
    .setJdbcUsername("dev-user")
    .setJdbcPassword("putao.123")
    .setDataBase("testworkflow")
    .setJdbcDriver("com.mysql.jdbc.Driver")

    .setDatabaseSchemaUpdate(ProcessEngineConfiguration.DB_SCHEMA_UPDATE_FALSE);

    ProcessEngine processEngine = cfg.buildProcessEngine();

    RepositoryService repositoryService = processEngine.getRepositoryService();
    Deployment deployment = repositoryService.createDeployment()
    .addClasspathResource("./holiday-request.bpmn20.xml")
    .deploy();

    ProcessDefinition processDefinition = repositoryService.createProcessDefinitionQuery()
    .deploymentId(deployment.getId())
    .singleResult();
    writefln("Found process definition : " ~ processDefinition.getName());


    writefln("Who are you?");
    String employee = new String(strip(stdin.readln()));


    writefln("How many holidays do you want to request?");

    Integer nrOfHolidays = Integer.valueOf(strip(stdin.readln()));

    writeln("Why do you need them?");
    String description = new String(strip(stdin.readln()));

    RuntimeService runtimeService = processEngine.getRuntimeService();

    Map!(string, Object) variables = new HashMap!(string, Object);
    variables.put("employee", employee);
    variables.put("nrOfHolidays", nrOfHolidays);
    variables.put("description", description);

    ProcessInstance processInstance =
    runtimeService.startProcessInstanceByKey("holidayRequest", variables);


    TaskService taskService = processEngine.getTaskService();
    List!Task tasks = taskService.createTaskQuery().taskCandidateGroup("managers").list();
    writefln("You have %d tasks:",tasks.size());
    for (int i = 0; i < tasks.size(); ++i)
    {
      writefln("%d)%s " , i+1,tasks.get(i).getName());
    }

    writefln("Which task would you like to complete?");
    int taskIndex = to!int(strip(stdin.readln()));
    Task task = tasks.get(taskIndex - 1);
    Map!(string, Object) processVariables = taskService.getVariables(task.getId());
    writefln("%s wants %d  of holidays for %s. Do you approve this?" , (cast(String)processVariables.get("employee")).value , (cast(Integer)processVariables.get("nrOfHolidays")).intValue , (cast(String)processVariables.get("description")).value);

    bool approved = (strip(stdin.readln()) == "y");
    variables = new HashMap!(string, Object);
    variables.put("approved", new Boolean(approved));
    variables.put("manager", new String("putao"));
    taskService.complete(task.getId(), variables);

}
