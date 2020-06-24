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

module flow.common.api.FlowableClassLoadingException;

import flow.common.api.FlowableException;



/**
 * Runtime exception indicating the requested class was not found or an error occurred while loading the class.
 *
 * @author Frederik Heremans
 */
class FlowableClassLoadingException : FlowableException {

    protected string className;

    this(string className, Throwable cause) {
        super(getExceptionMessageMessage(className, cause), cause);
        this.className = className;
    }

    /**
     * Returns the name of the class this exception is related to.
     */
    public string getClassName() {
        return className;
    }

    private static string getExceptionMessageMessage(string className, Throwable cause) {
      return "Could not load class: " ~ className;
        //if (cause instanceof ClassNotFoundException) {
        //    return "Class not found: " + className;
        //} else {
        //    return "Could not load class: " + className;
        //}
    }

}
