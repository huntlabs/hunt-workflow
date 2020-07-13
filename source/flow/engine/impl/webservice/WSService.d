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
//import hunt.collection.HashMap;
//import hunt.collection.Map;
//
//import flow.common.util.ReflectUtil;
//import flow.engine.impl.bpmn.webservice.BpmnInterface;
//import flow.engine.impl.bpmn.webservice.BpmnInterfaceImplementation;
//import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
//
///**
// * Represents a WS implementation of a {@link BpmnInterface}
// *
// * @author Esteban Robles Luna
// */
//class WSService implements BpmnInterfaceImplementation {
//
//    protected string name;
//
//    protected string location;
//
//    protected Map!(string, WSOperation) operations;
//
//    protected string wsdlLocation;
//
//    protected SyncWebServiceClient client;
//
//    public WSService(string name, string location, string wsdlLocation) {
//        this.name = name;
//        this.location = location;
//        this.operations = new HashMap<>();
//        this.wsdlLocation = wsdlLocation;
//    }
//
//    public WSService(string name, string location, SyncWebServiceClient client) {
//        this.name = name;
//        this.location = location;
//        this.operations = new HashMap<>();
//        this.client = client;
//    }
//
//    public void addOperation(WSOperation operation) {
//        this.operations.put(operation.getName(), operation);
//    }
//
//    SyncWebServiceClient getClient() {
//        if (this.client is null) {
//            // TODO refactor to use configuration
//            SyncWebServiceClientFactory factory = (SyncWebServiceClientFactory) ReflectUtil.instantiate(ProcessEngineConfigurationImpl.DEFAULT_WS_SYNC_FACTORY);
//            this.client = factory.create(this.wsdlLocation);
//        }
//        return this.client;
//    }
//
//    override
//    public string getName() {
//        return this.name;
//    }
//
//    public string getLocation() {
//        return this.location;
//    }
//}
