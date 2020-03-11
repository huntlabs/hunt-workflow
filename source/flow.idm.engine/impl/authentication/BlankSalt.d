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

module flow.idm.engine.authentication.BlankSalt;
import flow.idm.api.PasswordSalt;
import flow.idm.api.PasswordSaltProvider;
import std.concurrency : initOnce;
/**
 * @author faizal-manan
 */
class BlankSalt : PasswordSalt {

    //private static  BlankSalt INSTANCE = new BlankSalt();

    this() {
    }

  static BlankSalt  getInstance() {
    __gshared BlankSalt  inst;
    return initOnce!inst(new BlankSalt);
  }

    //public static BlankSalt getInstance() {
    //    return INSTANCE;
    //}

    public PasswordSaltProvider getSource() {
        return BlankSaltProvider.getInstance();
    }

    public void setSource(PasswordSaltProvider source) {
        //nothing here
    }

}
