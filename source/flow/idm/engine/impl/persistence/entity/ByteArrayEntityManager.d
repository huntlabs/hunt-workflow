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
module flow.idm.engine.impl.persistence.entity.ByteArrayEntityManager;

import hunt.collection.List;

import flow.common.persistence.entity.EntityManager;
import flow.idm.engine.impl.persistence.entity.IdmByteArrayEntity;

/**
 * @author Joram Barrez
 */
interface ByteArrayEntityManager : EntityManager!IdmByteArrayEntity {

    /**
     * Returns all {@link IdmByteArrayEntity}.
     */
    List!IdmByteArrayEntity findAll();

    /**
     * Deletes the {@link IdmByteArrayEntity} with the given id from the database. Important: this operation will NOT do any optimistic locking, to avoid loading the bytes in memory. So use this method
     * only in conjunction with an entity that has optimistic locking!.
     */
    void deleteByteArrayById(string byteArrayEntityId);

}
