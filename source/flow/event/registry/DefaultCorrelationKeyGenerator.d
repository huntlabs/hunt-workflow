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

module flow.event.registry.DefaultCorrelationKeyGenerator;
//import java.math.BigInteger;
//import java.nio.charset.StandardCharsets;
//import java.security.MessageDigest;
//import java.security.NoSuchAlgorithmException;
import hunt.collection.ArrayList;
import hunt.collection;
import hunt.collection.List;
import hunt.collection.Map;
import hunt.Exceptions;
import flow.event.registry.api.CorrelationKeyGenerator;

/**
 * Default implementation of the {@link CorrelationKeyGenerator} interface.
 * This implementation provides a single hash value based on the data passed in.
 * All values in the data are used to generate the key.
 * <p>
 * This implementation is inspired by the Spring Batch DefaultJobKeyGenerator
 *
 * @author Filip Hrisafov
 */
class DefaultCorrelationKeyGenerator : CorrelationKeyGenerator!(Map(!string, Object)) {

    public string generateKey(Map!(string, Object) source) {
        implementationMissing(false);
        //StringBuilder sb = new StringBuilder();
        //List!string keys = new ArrayList!string(source.keySet());
        //Collections.sort(keys);
        //foreach (string key ; keys) {
        //    Object sourceValue = source.get(key);
        //    string value = sourceValue is null ? "" : sourceValue.toString();
        //    sb.append(key).append("=").append(value).append(";");
        //}
        //
        //MessageDigest digest;
        //try {
        //    digest = MessageDigest.getInstance("MD5");
        //} catch (NoSuchAlgorithmException e) {
        //    throw new IllegalStateException("MD5 algorithm not available. Fatal (should be in the JDK).");
        //}
        //
        //byte[] bytes = digest.digest(sb.toString().getBytes(StandardCharsets.UTF_8));
        //return string.format("%x", new BigInteger(1, bytes));
    }
}
