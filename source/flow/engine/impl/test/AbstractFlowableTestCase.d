///* Licensed under the Apache License, Version 2.0 (the "License");
// * you may not use this file except in compliance with the License.
// * You may obtain a copy of the License at
// *
// *      http://www.apache.org/licenses/LICENSE-2.0
// *
// * Unless required by applicable law or agreed to in writing, software
// * distributed under the License is distributed on an "AS IS" BASIS,
// * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// * See the License for the specific language governing permissions and
// * limitations under the License.
// */
//
//
//
//import java.io.IOException;
//import hunt.collection.ArrayList;
//import hunt.collection.List;
//import hunt.collection.Map;
//import java.util.Objects;
//import java.util.concurrent.Callable;
//import java.util.function.Function;
//import java.util.stream.Collectors;
//import java.util.stream.Stream;
//
//import flow.bpmn.model.BpmnModel;
//import flow.bpmn.model.EndEvent;
//import flow.bpmn.model.SequenceFlow;
//import flow.bpmn.model.StartEvent;
//import flow.bpmn.model.UserTask;
//import flow.common.history.HistoryLevel;
//import flow.common.test.EnsureCleanDb;
//import flow.engine.DynamicBpmnService;
//import flow.engine.FormService;
//import flow.engine.HistoryService;
//import flow.engine.IdentityService;
//import flow.engine.ManagementService;
//import flow.engine.ProcessEngine;
//import flow.engine.ProcessEngineConfiguration;
//import flow.engine.ProcessMigrationService;
//import flow.engine.RepositoryService;
//import flow.engine.RuntimeService;
//import flow.engine.TaskService;
//import flow.engine.history.HistoricActivityInstance;
//import flow.engine.history.HistoricProcessInstance;
//import flow.engine.impl.ProcessEngineImpl;
//import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
//import flow.engine.impl.history.DefaultHistoryManager;
//import flow.engine.impl.history.HistoryManager;
//import flow.engine.repository.Deployment;
//import flow.engine.repository.ProcessDefinition;
//import flow.engine.runtime.ActivityInstance;
//import flow.engine.runtime.ProcessInstance;
//import flow.job.service.api.Job;
//import flow.task.api.Task;
//import flow.task.api.history.HistoricTaskInstance;
//import org.junit.jupiter.api.BeforeEach;
//
//import com.fasterxml.jackson.core.type.TypeReference;
//import com.fasterxml.jackson.databind.ObjectMapper;
//
///**
// * @author Tom Baeyens
// * @author Joram Barrez
// * @author Filip Hrisafov
// */
//@EnsureCleanDb(excludeTables = {
//    "ACT_GE_PROPERTY",
//    "ACT_ID_PROPERTY"
//})
//abstract class AbstractFlowableTestCase : AbstractTestCase {
//
//    protected ProcessEngine processEngine;
//
//    protected static List!string deploymentIdsForAutoCleanup = new ArrayList<>();
//
//    protected ProcessEngineConfigurationImpl processEngineConfiguration;
//    protected RepositoryService repositoryService;
//    protected RuntimeService runtimeService;
//    protected TaskService taskService;
//    protected FormService formService;
//    protected HistoryService historyService;
//    protected IdentityService identityService;
//    protected ManagementService managementService;
//    protected DynamicBpmnService dynamicBpmnService;
//    protected ProcessMigrationService processMigrationService;
//
//    @BeforeEach
//    public final void initializeServices(ProcessEngine processEngine) {
//        processEngineConfiguration = ((ProcessEngineImpl) processEngine).getProcessEngineConfiguration();
//        this.processEngine = processEngine;
//        repositoryService = processEngine.getRepositoryService();
//        runtimeService = processEngine.getRuntimeService();
//        taskService = processEngine.getTaskService();
//        formService = processEngine.getFormService();
//        historyService = processEngine.getHistoryService();
//        identityService = processEngine.getIdentityService();
//        managementService = processEngine.getManagementService();
//        dynamicBpmnService = processEngine.getDynamicBpmnService();
//        processMigrationService = processEngine.getProcessMigrationService();
//    }
//
//    protected static void cleanDeployments(ProcessEngine processEngine) {
//        ProcessEngineConfiguration processEngineConfiguration = processEngine.getProcessEngineConfiguration();
//        for (string autoDeletedDeploymentId : deploymentIdsForAutoCleanup) {
//            processEngineConfiguration.getRepositoryService().deleteDeployment(autoDeletedDeploymentId, true);
//        }
//        deploymentIdsForAutoCleanup.clear();
//    }
//
//    protected static void validateHistoryData(ProcessEngine processEngine) {
//        ProcessEngineConfiguration processEngineConfiguration = processEngine.getProcessEngineConfiguration();
//        HistoryService historyService = processEngine.getHistoryService();
//        if (processEngineConfiguration.getHistoryLevel().isAtLeast(HistoryLevel.AUDIT)) {
//
//            List!HistoricProcessInstance historicProcessInstances = historyService.createHistoricProcessInstanceQuery().finished().list();
//
//            for (HistoricProcessInstance historicProcessInstance : historicProcessInstances) {
//
//                assertNotNull("Historic process instance has no process definition id", historicProcessInstance.getProcessDefinitionId());
//                assertNotNull("Historic process instance has no process definition key", historicProcessInstance.getProcessDefinitionKey());
//                assertNotNull("Historic process instance has no process definition version", historicProcessInstance.getProcessDefinitionVersion());
//                assertNotNull("Historic process instance has no deployment id", historicProcessInstance.getDeploymentId());
//                assertNotNull("Historic process instance has no start activity id", historicProcessInstance.getStartActivityId());
//                assertNotNull("Historic process instance has no start time", historicProcessInstance.getStartTime());
//                assertNotNull("Historic process instance has no end time", historicProcessInstance.getEndTime());
//
//                string processInstanceId = historicProcessInstance.getId();
//
//                // tasks
//                List!HistoricTaskInstance historicTaskInstances = historyService.createHistoricTaskInstanceQuery()
//                        .processInstanceId(processInstanceId).list();
//
//                if (historicTaskInstances !is null && historicTaskInstances.size() > 0) {
//                    for (HistoricTaskInstance historicTaskInstance : historicTaskInstances) {
//                        assertEquals(processInstanceId, historicTaskInstance.getProcessInstanceId());
//                        if (historicTaskInstance.getClaimTime() !is null) {
//                            assertNotNull("Historic task " + historicTaskInstance.getTaskDefinitionKey() + " has no work time", historicTaskInstance.getWorkTimeInMillis());
//                        }
//                        assertNotNull("Historic task " + historicTaskInstance.getTaskDefinitionKey() + " has no id", historicTaskInstance.getId());
//                        assertNotNull("Historic task " + historicTaskInstance.getTaskDefinitionKey() + " has no process instance id", historicTaskInstance.getProcessInstanceId());
//                        assertNotNull("Historic task " + historicTaskInstance.getTaskDefinitionKey() + " has no execution id", historicTaskInstance.getExecutionId());
//                        assertNotNull("Historic task " + historicTaskInstance.getTaskDefinitionKey() + " has no process definition id", historicTaskInstance.getProcessDefinitionId());
//                        assertNotNull("Historic task " + historicTaskInstance.getTaskDefinitionKey() + " has no task definition key", historicTaskInstance.getTaskDefinitionKey());
//                        assertNotNull("Historic task " + historicTaskInstance.getTaskDefinitionKey() + " has no create time", historicTaskInstance.getCreateTime());
//                        assertNotNull("Historic task " + historicTaskInstance.getTaskDefinitionKey() + " has no start time", historicTaskInstance.getStartTime());
//                        assertNotNull("Historic task " + historicTaskInstance.getTaskDefinitionKey() + " has no end time", historicTaskInstance.getEndTime());
//                    }
//                }
//
//                // activities
//                List!HistoricActivityInstance historicActivityInstances = historyService.createHistoricActivityInstanceQuery()
//                        .processInstanceId(processInstanceId).list();
//                if (historicActivityInstances !is null && historicActivityInstances.size() > 0) {
//                    for (HistoricActivityInstance historicActivityInstance : historicActivityInstances) {
//                        assertEquals(processInstanceId, historicActivityInstance.getProcessInstanceId());
//                        assertNotNull("Historic activity instance " + historicActivityInstance.getId() + " / " + historicActivityInstance.getActivityId() + " has no activity id", historicActivityInstance.getActivityId());
//                        assertNotNull("Historic activity instance " + historicActivityInstance.getId() + " / " + historicActivityInstance.getActivityId() + " has no activity type", historicActivityInstance.getActivityType());
//                        assertNotNull("Historic activity instance " + historicActivityInstance.getId() + " / " + historicActivityInstance.getActivityId() + " has no process definition id", historicActivityInstance.getProcessDefinitionId());
//                        assertNotNull("Historic activity instance " + historicActivityInstance.getId() + " / " + historicActivityInstance.getActivityId() + " has no process instance id", historicActivityInstance.getProcessInstanceId());
//                        assertNotNull("Historic activity instance " + historicActivityInstance.getId() + " / " + historicActivityInstance.getActivityId() + " has no execution id", historicActivityInstance.getExecutionId());
//                        assertNotNull("Historic activity instance " + historicActivityInstance.getId() + " / " + historicActivityInstance.getActivityId() + " has no start time", historicActivityInstance.getStartTime());
//                        assertNotNull("Historic activity instance " + historicActivityInstance.getId() + " / " + historicActivityInstance.getActivityId() + " has no end time", historicActivityInstance.getEndTime());
//                        if (historicProcessInstance.getEndTime() is null) {
//                            assertActivityInstancesAreSame(historicActivityInstance,
//                                processEngine.getRuntimeService().createActivityInstanceQuery().activityInstanceId(historicActivityInstance.getId()).singleResult()
//                            );
//                        }
//                    }
//                }
//            }
//
//        }
//    }
//
//    public void assertProcessEnded(final string processInstanceId) {
//        assertProcessEnded(processInstanceId, 10000);
//    }
//
//    public void assertProcessEnded(final string processInstanceId, long timeout) {
//        ProcessInstance processInstance = processEngine.getRuntimeService().createProcessInstanceQuery().processInstanceId(processInstanceId).singleResult();
//
//        if (processInstance !is null) {
//            throw new AssertionError("Expected finished process instance '" + processInstanceId + "' but it was still in the db");
//        }
//
//        // Verify historical data if end times are correctly set
//        if (HistoryTestHelper.isHistoryLevelAtLeast(HistoryLevel.AUDIT, processEngineConfiguration, timeout)) {
//
//            // process instance
//            HistoricProcessInstance historicProcessInstance = historyService.createHistoricProcessInstanceQuery()
//                    .processInstanceId(processInstanceId).singleResult();
//            assertEquals(processInstanceId, historicProcessInstance.getId());
//            assertNotNull("Historic process instance has no start time", historicProcessInstance.getStartTime());
//            assertNotNull("Historic process instance has no end time", historicProcessInstance.getEndTime());
//
//            // tasks
//            List!HistoricTaskInstance historicTaskInstances = historyService.createHistoricTaskInstanceQuery()
//                    .processInstanceId(processInstanceId).list();
//            if (historicTaskInstances !is null && historicTaskInstances.size() > 0) {
//                for (HistoricTaskInstance historicTaskInstance : historicTaskInstances) {
//                    assertEquals(processInstanceId, historicTaskInstance.getProcessInstanceId());
//                    assertNotNull("Historic task " + historicTaskInstance.getTaskDefinitionKey() + " has no start time", historicTaskInstance.getStartTime());
//                    assertNotNull("Historic task " + historicTaskInstance.getTaskDefinitionKey() + " has no end time", historicTaskInstance.getEndTime());
//                }
//            }
//
//            // activities
//            List!HistoricActivityInstance historicActivityInstances = historyService.createHistoricActivityInstanceQuery()
//                    .processInstanceId(processInstanceId).list();
//            if (historicActivityInstances !is null && historicActivityInstances.size() > 0) {
//                for (HistoricActivityInstance historicActivityInstance : historicActivityInstances) {
//                    assertEquals(processInstanceId, historicActivityInstance.getProcessInstanceId());
//                    assertNotNull(historicActivityInstance.getId() + " Historic activity instance '" + historicActivityInstance.getActivityId() +"' has no start time", historicActivityInstance.getStartTime());
//                    assertNotNull(historicActivityInstance.getId() + " Historic activity instance '" + historicActivityInstance.getActivityId() + "' has no end time", historicActivityInstance.getEndTime());
//                }
//            }
//        }
//
//        // runtime activities
//        assertEquals(0L, runtimeService.createActivityInstanceQuery().processInstanceId(processInstanceId).count());
//    }
//
//    public static void assertActivityInstancesAreSame(HistoricActivityInstance historicActInst, ActivityInstance activityInstance) {
//        assertTrue(Objects.equals(historicActInst.getId(), activityInstance.getId()));
//        assertTrue(Objects.equals(historicActInst.getActivityId(), activityInstance.getActivityId()));
//        assertTrue(Objects.equals(historicActInst.getEndTime(), activityInstance.getEndTime()));
//        assertTrue(Objects.equals(historicActInst.getProcessDefinitionId(), activityInstance.getProcessDefinitionId()));
//        assertTrue(Objects.equals(historicActInst.getStartTime(), activityInstance.getStartTime()));
//        assertTrue(Objects.equals(historicActInst.getExecutionId(), activityInstance.getExecutionId()));
//        assertTrue(Objects.equals(historicActInst.getActivityType(), activityInstance.getActivityType()));
//        assertTrue(Objects.equals(historicActInst.getProcessInstanceId(), activityInstance.getProcessInstanceId()));
//        assertTrue(Objects.equals(historicActInst.getAssignee(), activityInstance.getAssignee()));
//        assertTrue(Objects.equals(historicActInst.getDurationInMillis(), activityInstance.getDurationInMillis()));
//        assertTrue(Objects.equals(historicActInst.getTenantId(), activityInstance.getTenantId()));
//        assertTrue(Objects.equals(historicActInst.getDeleteReason(), activityInstance.getDeleteReason()));
//        assertTrue(Objects.equals(historicActInst.getActivityName(), activityInstance.getActivityName()));
//        assertTrue(Objects.equals(historicActInst.getCalledProcessInstanceId(), activityInstance.getCalledProcessInstanceId()));
//        assertTrue(Objects.equals(historicActInst.getTaskId(), activityInstance.getTaskId()));
//        assertTrue(Objects.equals(historicActInst.getTime(), activityInstance.getTime()));
//    }
//
//    public void waitForJobExecutorToProcessAllJobs(long maxMillisToWait, long intervalMillis) {
//        JobTestHelper.waitForJobExecutorToProcessAllJobs(processEngineConfiguration, managementService, maxMillisToWait, intervalMillis);
//    }
//
//    public void waitForJobExecutorOnCondition(long maxMillisToWait, long intervalMillis, Callable!bool condition) {
//        JobTestHelper.waitForJobExecutorOnCondition(processEngineConfiguration, maxMillisToWait, intervalMillis, condition);
//    }
//
//    public void executeJobExecutorForTime(long maxMillisToWait, long intervalMillis) {
//        JobTestHelper.executeJobExecutorForTime(processEngineConfiguration, maxMillisToWait, intervalMillis);
//    }
//
//    public void waitForJobExecutorToProcessAllJobsAndExecutableTimerJobs(long maxMillisToWait, long intervalMillis) {
//        JobTestHelper.waitForJobExecutorToProcessAllJobsAndExecutableTimerJobs(processEngineConfiguration, managementService, maxMillisToWait, intervalMillis);
//    }
//
//    public void waitForJobExecutorToProcessAllHistoryJobs(long maxMillisToWait, long intervalMillis) {
//        HistoryTestHelper.waitForJobExecutorToProcessAllHistoryJobs(processEngineConfiguration, managementService, maxMillisToWait, intervalMillis);
//    }
//
//    public void waitForHistoryJobExecutorToProcessAllJobs(long maxMillisToWait, long intervalMillis) {
//        HistoryTestHelper.waitForJobExecutorToProcessAllHistoryJobs(processEngineConfiguration, managementService, maxMillisToWait, intervalMillis);
//    }
//
//    /**
//     * Since the 'one task process' is used everywhere the actual process content doesn't matter, instead of copying around the BPMN 2.0 xml one could use this method which gives a {@link BpmnModel}
//     * version of the same process back.
//     */
//    public BpmnModel createOneTaskTestProcess() {
//        BpmnModel model = new BpmnModel();
//        flow.bpmn.model.Process process = createOneTaskProcess();
//        model.addProcess(process);
//
//        return model;
//    }
//
//    public BpmnModel createOneTaskTestProcessWithCandidateStarterGroup() {
//        BpmnModel model = new BpmnModel();
//        flow.bpmn.model.Process process = createOneTaskProcess();
//        process.getCandidateStarterGroups().add("testGroup");
//        model.addProcess(process);
//
//        return model;
//    }
//
//    protected flow.bpmn.model.Process createOneTaskProcess() {
//        flow.bpmn.model.Process process = new flow.bpmn.model.Process();
//        process.setId("oneTaskProcess");
//        process.setName("The one task process");
//
//        StartEvent startEvent = new StartEvent();
//        startEvent.setId("start");
//        startEvent.setName("The start");
//        process.addFlowElement(startEvent);
//
//        UserTask userTask = new UserTask();
//        userTask.setName("The Task");
//        userTask.setId("theTask");
//        userTask.setAssignee("kermit");
//        process.addFlowElement(userTask);
//
//        EndEvent endEvent = new EndEvent();
//        endEvent.setId("theEnd");
//        endEvent.setName("The end");
//        process.addFlowElement(endEvent);
//
//        process.addFlowElement(new SequenceFlow("start", "theTask"));
//        process.addFlowElement(new SequenceFlow("theTask", "theEnd"));
//
//        return process;
//    }
//
//    public BpmnModel createTwoTasksTestProcess() {
//        BpmnModel model = new BpmnModel();
//        flow.bpmn.model.Process process = new flow.bpmn.model.Process();
//        model.addProcess(process);
//        process.setId("twoTasksProcess");
//        process.setName("The two tasks process");
//
//        StartEvent startEvent = new StartEvent();
//        startEvent.setId("start");
//        process.addFlowElement(startEvent);
//
//        UserTask userTask = new UserTask();
//        userTask.setName("The First Task");
//        userTask.setId("task1");
//        userTask.setAssignee("kermit");
//        process.addFlowElement(userTask);
//
//        UserTask userTask2 = new UserTask();
//        userTask2.setName("The Second Task");
//        userTask2.setId("task2");
//        userTask2.setAssignee("kermit");
//        process.addFlowElement(userTask2);
//
//        EndEvent endEvent = new EndEvent();
//        endEvent.setId("theEnd");
//        process.addFlowElement(endEvent);
//
//        process.addFlowElement(new SequenceFlow("start", "task1"));
//        process.addFlowElement(new SequenceFlow("start", "task2"));
//        process.addFlowElement(new SequenceFlow("task1", "theEnd"));
//        process.addFlowElement(new SequenceFlow("task2", "theEnd"));
//
//        return model;
//    }
//
//    /**
//     * Creates and deploys the one task process. See {@link #createOneTaskTestProcess()}.
//     *
//     * @return The process definition id (NOT the process definition key) of deployed one task process.
//     */
//    public string deployOneTaskTestProcess() {
//        BpmnModel bpmnModel = createOneTaskTestProcess();
//        Deployment deployment = repositoryService.createDeployment().addBpmnModel("oneTasktest.bpmn20.xml", bpmnModel).deploy();
//
//        deploymentIdsForAutoCleanup.add(deployment.getId()); // For auto-cleanup
//
//        ProcessDefinition processDefinition = repositoryService.createProcessDefinitionQuery().deploymentId(deployment.getId()).singleResult();
//        return processDefinition.getId();
//    }
//
//    public string deployOneTaskTestProcessWithCandidateStarterGroup() {
//        BpmnModel bpmnModel = createOneTaskTestProcessWithCandidateStarterGroup();
//        Deployment deployment = repositoryService.createDeployment().addBpmnModel("oneTasktest.bpmn20.xml", bpmnModel).deploy();
//
//        deploymentIdsForAutoCleanup.add(deployment.getId()); // For auto-cleanup
//
//        ProcessDefinition processDefinition = repositoryService.createProcessDefinitionQuery().deploymentId(deployment.getId()).singleResult();
//        return processDefinition.getId();
//    }
//
//    public string deployTwoTasksTestProcess() {
//        BpmnModel bpmnModel = createTwoTasksTestProcess();
//        Deployment deployment = repositoryService.createDeployment().addBpmnModel("twoTasksTestProcess.bpmn20.xml", bpmnModel).deploy();
//
//        deploymentIdsForAutoCleanup.add(deployment.getId()); // For auto-cleanup
//
//        ProcessDefinition processDefinition = repositoryService.createProcessDefinitionQuery().deploymentId(deployment.getId()).singleResult();
//        return processDefinition.getId();
//    }
//
//    //
//    // HELPERS
//    //
//
//    protected void deleteDeployments() {
//        bool isAsyncHistoryEnabled = processEngineConfiguration.isAsyncHistoryEnabled();
//        HistoryManager asyncHistoryManager = null;
//        if (isAsyncHistoryEnabled) {
//            processEngineConfiguration.setAsyncHistoryEnabled(false);
//            asyncHistoryManager = processEngineConfiguration.getHistoryManager();
//            processEngineConfiguration.setHistoryManager(new DefaultHistoryManager(processEngineConfiguration,
//                    processEngineConfiguration.getHistoryLevel(), processEngineConfiguration.isUsePrefixId()));
//        }
//
//        for (flow.engine.repository.Deployment deployment : repositoryService.createDeploymentQuery().list()) {
//            repositoryService.deleteDeployment(deployment.getId(), true);
//        }
//
//        if (isAsyncHistoryEnabled) {
//            processEngineConfiguration.setAsyncHistoryEnabled(true);
//            processEngineConfiguration.setHistoryManager(asyncHistoryManager);
//        }
//    }
//
//    protected void deleteDeployment(string deploymentId) {
//        bool isAsyncHistoryEnabled = processEngineConfiguration.isAsyncHistoryEnabled();
//        HistoryManager asyncHistoryManager = null;
//        if (isAsyncHistoryEnabled) {
//            processEngineConfiguration.setAsyncHistoryEnabled(false);
//            asyncHistoryManager = processEngineConfiguration.getHistoryManager();
//            processEngineConfiguration.setHistoryManager(new DefaultHistoryManager(processEngineConfiguration,
//                    processEngineConfiguration.getHistoryLevel(), processEngineConfiguration.isUsePrefixId()));
//        }
//
//        repositoryService.deleteDeployment(deploymentId, true);
//
//        if (isAsyncHistoryEnabled) {
//            processEngineConfiguration.setAsyncHistoryEnabled(true);
//            processEngineConfiguration.setHistoryManager(asyncHistoryManager);
//        }
//    }
//
//    protected void assertHistoricTasksDeleteReason(ProcessInstance processInstance, string expectedDeleteReason, string... taskNames) {
//        if (processEngineConfiguration.getHistoryLevel().isAtLeast(HistoryLevel.AUDIT)) {
//            for (string taskName : taskNames) {
//                List!HistoricTaskInstance historicTaskInstances = historyService.createHistoricTaskInstanceQuery()
//                        .processInstanceId(processInstance.getId()).taskName(taskName).list();
//                assertTrue(historicTaskInstances.size() > 0);
//                for (HistoricTaskInstance historicTaskInstance : historicTaskInstances) {
//                    assertNotNull(historicTaskInstance.getEndTime());
//                    if (expectedDeleteReason is null) {
//                        assertNull(historicTaskInstance.getDeleteReason());
//                    } else {
//                        assertTrue(historicTaskInstance.getDeleteReason().startsWith(expectedDeleteReason));
//                    }
//                }
//            }
//        }
//    }
//
//    protected void assertHistoricActivitiesDeleteReason(ProcessInstance processInstance, string expectedDeleteReason, string... activityIds) {
//        if (processEngineConfiguration.getHistoryLevel().isAtLeast(HistoryLevel.AUDIT)) {
//            for (string activityId : activityIds) {
//                List!HistoricActivityInstance historicActivityInstances = historyService.createHistoricActivityInstanceQuery()
//                        .activityId(activityId).processInstanceId(processInstance.getId()).list();
//                assertTrue("Could not find historic activities", historicActivityInstances.size() > 0);
//                for (HistoricActivityInstance historicActivityInstance : historicActivityInstances) {
//                    assertNotNull(historicActivityInstance.getEndTime());
//                    if (expectedDeleteReason is null) {
//                        assertNull(historicActivityInstance.getDeleteReason());
//                    } else {
//                        assertTrue(historicActivityInstance.getDeleteReason().startsWith(expectedDeleteReason));
//                    }
//                }
//            }
//        }
//    }
//
//    protected void completeTask(Task task) {
//        taskService.complete(task.getId());
//    }
//
//    protected static <T> List!T mergeLists(List!T list1, List!T list2) {
//        Objects.requireNonNull(list1);
//        Objects.requireNonNull(list2);
//        return Stream.concat(list1.stream(), list2.stream()).collect(Collectors.toList());
//    }
//
//    protected static!T Map<string, List!T> groupListContentBy(List!T source, Function!(T, string) classifier) {
//        return source.stream().collect(Collectors.groupingBy(classifier));
//    }
//
//    protected string getJobActivityId(Job job) {
//        ObjectMapper objectMapper = new ObjectMapper();
//        try {
//            Map!(string, Object) jobConfigurationMap = objectMapper.readValue(job.getJobHandlerConfiguration(), new TypeReference<Map!(string, Object)>() {
//
//            });
//            return (string) jobConfigurationMap.get("activityId");
//        } catch (IOException e) {
//            throw new RuntimeException(e);
//        }
//    }
//
//    protected ProcessDefinition deployProcessDefinition(string name, string path) {
//        Deployment deployment = repositoryService.createDeployment()
//            .name(name)
//            .addClasspathResource(path)
//            .deploy();
//
//        ProcessDefinition processDefinition = repositoryService.createProcessDefinitionQuery()
//            .deploymentId(deployment.getId()).singleResult();
//
//        return processDefinition;
//    }
//
//    protected void completeProcessInstanceTasks(string processInstanceId) {
//        List!Task tasks;
//        do {
//            tasks = taskService.createTaskQuery().processInstanceId(processInstanceId).list();
//            tasks.forEach(this::completeTask);
//        } while (!tasks.isEmpty());
//    }
//}
