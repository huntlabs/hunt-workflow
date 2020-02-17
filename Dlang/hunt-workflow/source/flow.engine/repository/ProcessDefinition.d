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


import flow.engine.FormService;
import flow.engine.RepositoryService;
import flow.engine.runtime.ProcessInstance;

/**
 * An object structure representing an executable process composed of activities and transitions.
 * 
 * Business processes are often created with graphical editors that store the process definition in certain file format. 
 * These files can be added to a {@link Deployment} artifact, such as for example a Business Archive (.bar) file.
 * 
 * At deploy time, the engine will then parse the process definition files to an executable instance of this class, 
 * that can be used to start a {@link ProcessInstance}.
 * 
 * @author Tom Baeyens
 * @author Joram Barez
 * @author Daniel Meyer
 */
interface ProcessDefinition {

    /** unique identifier */
    string getId();

    /**
     * category name which is derived from the targetNamespace attribute in the definitions element
     */
    string getCategory();

    /** label used for display purposes */
    string getName();

    /** unique name for all versions this process definitions */
    string getKey();

    /** description of this process **/
    string getDescription();

    /** version of this process definition */
    int getVersion();

    /**
     * name of {@link RepositoryService#getResourceAsStream(string, string) the resource} of this process definition.
     */
    string getResourceName();

    /** The deployment in which this process definition is contained. */
    string getDeploymentId();

    /** The resource name in the deployment of the diagram image (if any). */
    string getDiagramResourceName();

    /**
     * Does this process definition has a {@link FormService#getStartFormData(string) start form key}.
     */
    bool hasStartFormKey();

    /**
     * Does this process definition has a graphical notation defined (such that a diagram can be generated)?
     */
    bool hasGraphicalNotation();

    /** Returns true if the process definition is in suspended state. */
    bool isSuspended();

    /** The tenant identifier of this process definition */
    string getTenantId();
    
    /** The derived from process definition value when this is a dynamic process definition */
    string getDerivedFrom();

    /** The root derived from process definition value when this is a dynamic process definition */
    string getDerivedFromRoot();

    /** The derived version of the process definition */
    int getDerivedVersion();

    /** The engine version for this process definition (5 or 6) */
    string getEngineVersion();

}
