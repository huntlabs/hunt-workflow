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
module flow.idm.engine.impl.persistence.entity.UserEntity;

import flow.common.db.HasRevision;
import flow.common.persistence.entity.Entity;
import flow.idm.api.Picture;
import flow.idm.api.User;
import flow.idm.engine.impl.persistence.entity.ByteArrayRef;

/**
 * @author Tom Baeyens
 * @author Arkadiy Gornovoy
 */
interface UserEntity : User, Entity, HasRevision {

    Picture getPicture();

    void setPicture(Picture picture);


    string getId();


    void setId(string id);


    string getFirstName();


    void setFirstName(string firstName);


    string getLastName();


    void setLastName(string lastName);


    string getDisplayName();


    void setDisplayName(string displayName);


    string getEmail();


    void setEmail(string email);


    string getPassword();


    void setPassword(string password);


    bool isPictureSet();

    ByteArrayRef getPictureByteArrayRef();

}
