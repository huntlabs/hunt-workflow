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
module flow.idm.engine.authentication.PasswordSaltImpl;

import flow.idm.api.PasswordSalt;
import flow.idm.api.PasswordSaltProvider;

/**
 * @author faizal-manan
 */
class PasswordSaltImpl : PasswordSalt {

    private PasswordSaltProvider saltProvider;

    this(PasswordSaltProvider salt) {
        this.saltProvider = salt;
    }

    this(string salt) {
        this.saltProvider = new TextSaltProvider(salt);
    }

    public PasswordSaltProvider getSource() {
        return saltProvider;
    }

    public void setSource(PasswordSaltProvider source) {
        this.saltProvider = source;
    }
}
