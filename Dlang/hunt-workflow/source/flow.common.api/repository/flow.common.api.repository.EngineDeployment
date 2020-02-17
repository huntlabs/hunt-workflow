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

//          Copyright linse 2020. 
// Distributed under the Boost Software License, Version 1.0. 
//    (See accompanying file LICENSE_1_0.txt or copy at 
//          http://www.boost.org/LICENSE_1_0.txt)} 
 
module flow.common.api.repository.EngineDeployment; 
 
 
 


import java.util.Date;
import java.util.Map;

/**
 * Represents a deployment that is already present in the engine repository.
 * 
 * A deployment is a container for resources such as process definitions, case definitions, images, forms, etc.
 * 
 * @author Tijs Rademakers
 */
interface EngineDeployment {

    string getId();

    string getName();

    Date getDeploymentTime();

    string getCategory();

    string getKey();
    
    string getDerivedFrom();

    string getDerivedFromRoot();

    string getTenantId();
    
    string getEngineVersion();
    
    bool isNew();

    Map<string, EngineResource> getResources();
}
