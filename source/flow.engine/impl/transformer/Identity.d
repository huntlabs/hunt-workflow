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
module flow.engine.impl.transformer.Identity;

import flow.engine.impl.transformer.AbstractTransformer;
import std.concurrency : initOnce;
/**
 *
 *
 * @author Esteban Robles Luna
 */
class Identity : AbstractTransformer {

    //private static Identity instance = new Identity();
    //
    //public static synchronized Identity getInstance() {
    //    if (instance is null) {
    //        instance = new Identity();
    //    }
    //    return instance;
    //}
    //
    //private Identity() {
    //
    //}

    static Identity getInstance() {
      __gshared Identity inst;
      return initOnce!inst(new Identity());
    }

    override
    protected Object primTransform(Object anObject) {
        return anObject;
    }
}
