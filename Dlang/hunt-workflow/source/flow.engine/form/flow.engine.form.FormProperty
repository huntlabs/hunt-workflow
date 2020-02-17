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
 
module flow.engine.form.FormProperty; 
 
 
 


import java.io.Serializable;

import flow.engine.form.FormType;

/**
 * Represents a single property on a form.
 * 
 * @author Tom Baeyens
 */
interface FormProperty : Serializable {

    /**
     * The key used to submit the property in {@link FormService#submitStartFormData(string, java.util.Map)} or {@link FormService#submitTaskFormData(string, java.util.Map)}
     */
    string getId();

    /** The display label */
    string getName();

    /** Type of the property. */
    FormType getType();

    /** Optional value that should be used to display in this property */
    string getValue();

    /**
     * Is this property read to be displayed in the form and made accessible with the methods {@link FormService#getStartFormData(string)} and {@link FormService#getTaskFormData(string)}.
     */
    bool isReadable();

    /** Is this property expected when a user submits the form? */
    bool isWritable();

    /** Is this property a required input field */
    bool isRequired();
}
