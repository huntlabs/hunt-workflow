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

module flow.engine.compatibility.DefaultFlowable5CompatibilityHandlerFactory;



//import flow.engine.compatibility.Flowable5CompatibilityHandlerFactory;
//import flow.engine.compatibility.Flowable5CompatibilityHandler;
//
///**
// * @author Joram Barrez
// */
//class DefaultFlowable5CompatibilityHandlerFactory : Flowable5CompatibilityHandlerFactory {
//
//
//    protected string compatibilityHandlerClassName;
//
//    override
//    public Flowable5CompatibilityHandler createFlowable5CompatibilityHandler() {
//
//        if (compatibilityHandlerClassName is null) {
//            compatibilityHandlerClassName = "org.flowable.compatibility.DefaultFlowable5CompatibilityHandler";
//        }
//
//        try {
//            Flowable5CompatibilityHandler handler = (Flowable5CompatibilityHandler) Class.forName(compatibilityHandlerClassName).newInstance();
//            return handler;
//        } catch (Exception e) {
//            LOGGER.info("Flowable 5 compatibility handler implementation not found or error during instantiation : {}. Flowable 5 backwards compatibility disabled.",
//                    e.getMessage());
//        }
//        return null;
//    }
//
//    public string getCompatibilityHandlerClassName() {
//        return compatibilityHandlerClassName;
//    }
//
//    public void setCompatibilityHandlerClassName(string compatibilityHandlerClassName) {
//        this.compatibilityHandlerClassName = compatibilityHandlerClassName;
//    }
//
//}
