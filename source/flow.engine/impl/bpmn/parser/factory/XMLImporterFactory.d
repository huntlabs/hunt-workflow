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


import org.flowable.bpmn.model.Import;
import flow.common.api.FlowableException;
import flow.engine.impl.bpmn.behavior.WebServiceActivityBehavior;
import flow.engine.impl.bpmn.parser.XMLImporter;
import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;

/**
 * Factory class used by the {@link WebServiceActivityBehavior} to instantiate {@link XMLImporter}.
 * 
 * You can provide your own implementation of this class to provide your own XML/WSDL importer.
 * 
 * An instance of this interface can be injected in the {@link ProcessEngineConfigurationImpl} and its subclasses.
 * 
 * @author Christophe DENEUX
 */
interface XMLImporterFactory {

    public XMLImporter createXMLImporter(Import theImport) throws FlowableException;
}
