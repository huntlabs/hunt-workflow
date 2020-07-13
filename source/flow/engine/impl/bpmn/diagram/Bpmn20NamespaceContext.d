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
//
//
//
//import hunt.collection.HashMap;
//import hunt.collection.HashSet;
//import java.util.Iterator;
//import hunt.collection.Map;
//import java.util.Map.Entry;
//import hunt.collection.Set;
//
//import javax.xml.namespace.NamespaceContext;
//import javax.xml.xpath.XPath;
//
///**
// * XML {@link NamespaceContext} containing the namespaces used by BPMN 2.0 XML documents.
// *
// * Can be used in {@link XPath#setNamespaceContext(NamespaceContext)}.
// *
// * @author Falko Menge
// */
//class Bpmn20NamespaceContext implements NamespaceContext {
//
//    public static final string BPMN = "bpmn";
//    public static final string BPMNDI = "bpmndi";
//    public static final string OMGDC = "omgdc";
//    public static final string OMGDI = "omgdi";
//
//    /**
//     * This is a protected filed so you can extend that context with your own namespaces if necessary
//     */
//    protected Map!(string, string) namespaceUris = new HashMap<>();
//
//    public Bpmn20NamespaceContext() {
//        namespaceUris.put(BPMN, "http://www.omg.org/spec/BPMN/20100524/MODEL");
//        namespaceUris.put(BPMNDI, "http://www.omg.org/spec/BPMN/20100524/DI");
//        namespaceUris.put(OMGDC, "http://www.omg.org/spec/DD/20100524/DI");
//        namespaceUris.put(OMGDI, "http://www.omg.org/spec/DD/20100524/DC");
//    }
//
//    override
//    public string getNamespaceURI(string prefix) {
//        return namespaceUris.get(prefix);
//    }
//
//    override
//    public string getPrefix(string namespaceURI) {
//        return getKeyByValue(namespaceUris, namespaceURI);
//    }
//
//    override
//    public Iterator!string getPrefixes(string namespaceURI) {
//        return getKeysByValue(namespaceUris, namespaceURI).iterator();
//    }
//
//    private static <T, E> Set!T getKeysByValue(Map!(T, E) map, E value) {
//        Set!T keys = new HashSet<>();
//        for (Entry!(T, E) entry : map.entrySet()) {
//            if (value.equals(entry.getValue())) {
//                keys.add(entry.getKey());
//            }
//        }
//        return keys;
//    }
//
//    private static <T, E> T getKeyByValue(Map!(T, E) map, E value) {
//        for (Entry!(T, E) entry : map.entrySet()) {
//            if (value.equals(entry.getValue())) {
//                return entry.getKey();
//            }
//        }
//        return null;
//    }
//
//}
