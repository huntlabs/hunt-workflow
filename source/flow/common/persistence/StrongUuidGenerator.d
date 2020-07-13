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
module flow.common.persistence.StrongUuidGenerator;


//import com.fasterxml.uuid.EthernetAddress;
//import com.fasterxml.uuid.Generators;
//import com.fasterxml.uuid.impl.TimeBasedGenerator;

import flow.common.cfg.IdGenerator;
import std.uuid;
/**
 * {@link IdGenerator} implementation based on the current time and the ethernet address of the machine it is running on.
 *
 * @author Tijs Rademakers
 * @author Joram Barrez
 */
class StrongUuidGenerator : IdGenerator {

    // different ProcessEngines on the same classloader share one generator.
    //protected static  TimeBasedGenerator timeBasedGenerator;


    this() {
        //ensureGeneratorInitialized();
    }

    //protected void ensureGeneratorInitialized() {
    //    if (timeBasedGenerator is null) {
    //        synchronized (StrongUuidGenerator.class) {
    //            if (timeBasedGenerator is null) {
    //                timeBasedGenerator = Generators.timeBasedGenerator(EthernetAddress.fromInterface());
    //            }
    //        }
    //    }
    //}

    public string getNextId() {
        return randomUUID().toString();
    }

}
