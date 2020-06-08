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


import hunt.collection.Map;

import flow.bpmn.model.Import;
import flow.engine.impl.bpmn.data.StructureDefinition;
import flow.engine.impl.webservice.WSOperation;
import flow.engine.impl.webservice.WSService;

/**
 * A XML importer
 *
 * @author Esteban Robles Luna
 */
interface XMLImporter {

    /**
     * Imports the definitions in the XML declared in element
     *
     * @param theImport
     *            the declarations to be imported
     * @param sourceSystemId
     */
    void importFrom(Import theImport, string sourceSystemId);

    Map!(string, StructureDefinition) getStructures();

    Map!(string, WSService) getServices();

    Map!(string, WSOperation) getOperations();
}
