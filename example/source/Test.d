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

void main() {
    // 首先实例化ProcessEngine，线程安全对象，一般全局只有一个即可，从ProcessEngineConfiguration创建的话，可以调整一些
    // 配置，通常我们会从XML中创建，至少要配置一个JDBC连接
    // 如果是在Spring的配置中，使用SpringProcessEngineConfiguration

    ProcessEngineConfiguration cfg = new StandaloneProcessEngineConfiguration()
    //                .setJdbcUrl("jdbc:h2:mem:flowable;DB_CLOSE_DELAY=-1")
    //                .setJdbcDriver("org.h2.Driver")
    //                .setJdbcUsername("sa")
    .setJdbcPassword("")
    .setJdbcUrl("jdbc:mysql://10.1.223.62:3306/workflow")
    .setJdbcUsername("dev-user")
    .setJdbcPassword("putao.123")
    .setJdbcDriver("com.mysql.jdbc.Driver")

    // 如果数据表不存在的时候，自动创建数据表
    .setDatabaseSchemaUpdate(ProcessEngineConfiguration.DB_SCHEMA_UPDATE_FALSE);

    // 执行完成后，就可以开始创建我们的流程了
    ProcessEngine processEngine = cfg.buildProcessEngine();

    // 使用BPMN 2.0定义process。存储为XML，同时也是可以可视化的。NPMN 2.0标准可以让技术人员与业务人员都
    // 参与讨论业务流程中来

    // 部署流程
    RepositoryService repositoryService = processEngine.getRepositoryService();
    Deployment deployment = repositoryService.createDeployment()
    .addClasspathResource("./holiday-request.bpmn20.xml")
    .deploy();

    ProcessDefinition processDefinition = repositoryService.createProcessDefinitionQuery()
    .deploymentId(deployment.getId())
    .singleResult();
    writeln("Found process definition : " ~ processDefinition.getName());

    // 启动process实例，需要一些初始化的变量，这里我们简单的从Scanner中获取，一般在线上会通过接口传递过来
    //Scanner scanner= new Scanner(System.in);


    writeln("Who are you?");
    String employee = new String(stdin.readln());

    writeln("How many holidays do you want to request?");
    Integer nrOfHolidays = Integer.valueOf(stdin.readln());

    writeln("Why do you need them?");
    String description = new String(stdin.readln());

    RuntimeService runtimeService = processEngine.getRuntimeService();

    Map!(string, Object) variables = new HashMap!(string, Object);
    variables.put("employee", employee);
    variables.put("nrOfHolidays", nrOfHolidays);
    variables.put("description", description);

    // 当创建实例的时候，execution就被创建了，然后放在启动的事件中，这个事件可以从数据库中获取，
    // 用户后续等待这个状态即可
    ProcessInstance processInstance =
    runtimeService.startProcessInstanceByKey("holidayRequest", variables);

    // 在Flowable中数据库的事务对数据一致性起着关键性的作用。
    // 查询和完成任务

    TaskService taskService = processEngine.getTaskService();
    List!Task tasks = taskService.createTaskQuery().taskCandidateGroup("managers").list();
    writeln("You have %d tasks:",tasks.size());
    for (int i = 0; i < tasks.size(); ++i)
    {
      writeln("%d)%s " , i+1,tasks.get(i).getName());
    }

    writeln("Which task would you like to complete?");
    string index =  stdin.readln();
    int taskIndex = to!int(index);
    Task task = tasks.get(taskIndex - 1);
    Map!(string, Object) processVariables = taskService.getVariables(task.getId());
    writeln("%s wants %d  of holidays. Do you approve this?" , (cast(String)processVariables.get("employee")).value , (cast(Integer)processVariables.get("nrOfHolidays")).intValue);

    bool approved = (stdin.readln() == "y");
    variables = new HashMap!(string, Object);
    variables.put("approved", new Boolean(approved));
    taskService.complete(task.getId(), variables);

}
