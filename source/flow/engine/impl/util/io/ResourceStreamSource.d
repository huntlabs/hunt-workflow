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
//module flow.engine.impl.util.io.ResourceStreamSource;
//
//import java.io.BufferedInputStream;
//import java.io.InputStream;
//
//import flow.common.api.FlowableIllegalArgumentException;
//import flow.common.util.ReflectUtil;
//import flow.common.util.io.StreamSource;
//
///**
// * @author Tom Baeyens
// * @author Joram Barrez
// */
//class ResourceStreamSource implements StreamSource {
//
//    string resource;
//    ClassLoader classLoader;
//
//    public ResourceStreamSource(string resource) {
//        this.resource = resource;
//    }
//
//    public ResourceStreamSource(string resource, ClassLoader classLoader) {
//        this.resource = resource;
//        this.classLoader = classLoader;
//    }
//
//    override
//    public InputStream getInputStream() {
//        InputStream inputStream = null;
//        if (classLoader is null) {
//            inputStream = ReflectUtil.getResourceAsStream(resource);
//        } else {
//            inputStream = classLoader.getResourceAsStream(resource);
//        }
//        if (inputStream is null) {
//            throw new FlowableIllegalArgumentException("resource '" + resource + "' doesn't exist");
//        }
//        return new BufferedInputStream(inputStream);
//    }
//
//    override
//    public string toString() {
//        return "Resource[" + resource + "]";
//    }
//}
