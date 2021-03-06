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

module flow.engine.form.FormData;

import flow.engine.form.FormProperty;



import hunt.collection.List;

/**
 * Contains all information for displaying a form and serves as base interface for {@link StartFormData} and {@link TaskFormData}
 *
 * @author Tom Baeyens
 */
interface FormData {

    /**
     * User defined reference to a form. In the Explorer app, it is assumed that the form key specifies a resource in the deployment which is the template for the form. But users are free to use this
     * property differently.
     */
    string getFormKey();

    /**
     * The deployment id of the process definition to which this form is related
     */
    string getDeploymentId();

    /**
     * Properties containing the dynamic information that needs to be displayed in the form.
     */
    List!FormProperty getFormProperties();
}
