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
 
module flow.common.api.FlowableObjectNotFoundException;
 
import flow.common.api.FlowableException;
 


/**
 * An exception indicating that the object that is required or actioned on does not exist.
 * 
 * @author Frederik Heremans
 */
class FlowableObjectNotFoundException : FlowableException {

    private static final long serialVersionUID = 1L;

    private Class<?> objectClass;

    this(string message) {
        super(message);
    }

    public FlowableObjectNotFoundException(string message, Class<?> objectClass) {
        this(message, objectClass, null);
    }

    public FlowableObjectNotFoundException(Class<?> objectClass) {
        this(null, objectClass, null);
    }

    public FlowableObjectNotFoundException(string message, Class<?> objectClass, Throwable cause) {
        super(message, cause);
        this.objectClass = objectClass;
    }

    /**
     * The class of the object that was not found. Contains the interface-class of the object that was not found.
     */
    class<?> getObjectClass() {
        return objectClass;
    }
}
