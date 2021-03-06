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
//import hunt.collection.ArrayList;
//import hunt.collection.HashMap;
//import hunt.collection.LinkedHashMap;
//import hunt.collection.List;
//import hunt.collection.Map;
//
//import flow.common.cfg.TransactionContext;
//import flow.common.context.Context;
//import flow.common.interceptor.CommandContext;
//import flow.common.interceptor.CommandContextCloseListener;
//import flow.common.interceptor.Session;
//import flow.job.service.JobServiceConfiguration;
//import flow.job.service.impl.asyncexecutor.AsyncExecutor;
//import flow.job.service.impl.util.CommandContextUtil;
//
//import com.fasterxml.jackson.databind.node.ObjectNode;
//
//class AsyncHistorySession implements Session {
//
//    public static final string TIMESTAMP = "__timeStamp"; // Two underscores to avoid clashes with other fields
//
//    protected CommandContext commandContext;
//    protected AsyncHistoryListener asyncHistoryListener;
//    protected CommandContextCloseListener commandContextCloseListener;
//
//    // A list of the different types of history for which jobs will be created
//    // Note that the ordering of the types is important, as it will define the order of job creation.
//    protected List!string jobDataTypes;
//
//    protected TransactionContext transactionContext;
//    protected string tenantId;
//    protected Map<JobServiceConfiguration, AsyncHistorySessionData> sessionData;
//
//    public AsyncHistorySession(CommandContext commandContext, AsyncHistoryListener asyncHistoryJobListener) {
//        this.commandContext = commandContext;
//        this.asyncHistoryListener = asyncHistoryJobListener;
//
//        // A command context close listener is registered to avoid creating the async history data if it wouldn't be needed
//        initCommandContextCloseListener();
//
//        if (isAsyncHistoryExecutorEnabled()) {
//            // The transaction context is captured now, as it might be gone by the time
//            // the history job entities are created in the command context close listener
//            this.transactionContext = Context.getTransactionContext();
//        }
//    }
//
//    public AsyncHistorySession(CommandContext commandContext, AsyncHistoryListener asyncHistoryJobListener, List!string jobDataTypes) {
//        this(commandContext, asyncHistoryJobListener);
//        this.jobDataTypes = jobDataTypes;
//    }
//
//    protected bool isAsyncHistoryExecutorEnabled() {
//        AsyncExecutor asyncHistoryExecutor = CommandContextUtil.getJobServiceConfiguration(commandContext).getAsyncHistoryExecutor();
//        return asyncHistoryExecutor !is null && asyncHistoryExecutor.isActive();
//    }
//
//    protected void initCommandContextCloseListener() {
//        this.commandContextCloseListener = new AsyncHistorySessionCommandContextCloseListener(this, asyncHistoryListener);
//    }
//
//    public void addHistoricData(string type, ObjectNode data) {
//        JobServiceConfiguration jobServiceConfiguration = CommandContextUtil.getJobServiceConfiguration();
//        addHistoricData(jobServiceConfiguration, type, data, null);
//    }
//
//    public void addHistoricData(string type, ObjectNode data, string tenantId) {
//
//        // Different engines can call each other and all generate historical data.
//        // To make sure the context of where the data is coming from (and thus being able to process it in the right context),
//        // the JobService configuration is stored.
//        JobServiceConfiguration jobServiceConfiguration = CommandContextUtil.getJobServiceConfiguration();
//
//        addHistoricData(jobServiceConfiguration, type, data, tenantId);
//    }
//
//    public void addHistoricData(JobServiceConfiguration jobServiceConfiguration, string type, ObjectNode data) {
//        addHistoricData(jobServiceConfiguration, type, data, null);
//    }
//
//    public void addHistoricData(JobServiceConfiguration jobServiceConfiguration, string type, ObjectNode data, string tenantId) {
//        data.put(TIMESTAMP, AsyncHistoryDateUtil.formatDate(jobServiceConfiguration.getClock().getCurrentTime()));
//
//        if (sessionData is null) {
//            sessionData = new HashMap<>();
//            commandContext.addCloseListener(commandContextCloseListener);
//        }
//
//        AsyncHistorySessionData asyncHistorySessionData = sessionData.get(jobServiceConfiguration);
//        if (asyncHistorySessionData is null) {
//            asyncHistorySessionData = new AsyncHistorySessionData();
//            sessionData.put(jobServiceConfiguration, asyncHistorySessionData);
//        }
//
//        if (tenantId !is null) {
//            this.tenantId = tenantId;
//        }
//
//        asyncHistorySessionData.addJobData(type, data);
//    }
//
//    @Override
//    public void flush() {
//
//    }
//
//    @Override
//    public void close() {
//
//    }
//
//    public string getTenantId() {
//        return tenantId;
//    }
//
//    public void setTenantId(string tenantId) {
//        this.tenantId = tenantId;
//    }
//
//    public Map<JobServiceConfiguration, AsyncHistorySessionData> getSessionData() {
//        return sessionData;
//    }
//
//    public void setSessionData(Map<JobServiceConfiguration, AsyncHistorySessionData> sessionData) {
//        this.sessionData = sessionData;
//    }
//
//    public List!string getJobDataTypes() {
//        return jobDataTypes;
//    }
//
//    public void setJobDataTypes(List!string jobDataTypes) {
//        this.jobDataTypes = jobDataTypes;
//    }
//
//    public TransactionContext getTransactionContext() {
//        return transactionContext;
//    }
//
//    public void setTransactionContext(TransactionContext transactionContext) {
//        this.transactionContext = transactionContext;
//    }
//
//    /**
//     * Wrapper for the async history job data, to avoid messing with maps and lists.
//     */
//    public static class AsyncHistorySessionData {
//
//        protected Map<string, List<ObjectNode>> jobData = new LinkedHashMap<>(); // A map of {type, list of map-data (the historical event)}. Linked because insertion order is important
//
//        public Map<string, List<ObjectNode>> getJobData() {
//            return jobData;
//        }
//        public void setJobData(Map<string, List<ObjectNode>> jobData) {
//            this.jobData = jobData;
//        }
//        public void addJobData(string type, ObjectNode data) {
//            if (!jobData.containsKey(type)) {
//                jobData.put(type, new ArrayList<>(1));
//            }
//            jobData.get(type).add(data);
//        }
//
//    }
//}
