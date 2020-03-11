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
module flow.idm.engine.impl.persistence.entity.IdentityInfoEntityManagerImpl;


import hunt.collection.HashMap;
import hunt.collection.HashSet;
import hunt.collection.List;
import hunt.collection.Map;
import hunt.collection.Set;

import flow.idm.engine.IdmEngineConfiguration;
import flow.idm.engine.impl.persistence.entity.data.IdentityInfoDataManager;
import flow.idm.engine.impl.persistence.entity.AbstractIdmEngineEntityManager;
import flow.idm.engine.impl.persistence.entity.IdentityInfoEntity;
import flow.idm.engine.impl.persistence.entity.IdentityInfoEntityManager;
/**
 * @author Tom Baeyens
 * @author Joram Barrez
 */
class IdentityInfoEntityManagerImpl
    : AbstractIdmEngineEntityManager!(IdentityInfoEntity, IdentityInfoDataManager)
    , IdentityInfoEntityManager {

    this(IdmEngineConfiguration idmEngineConfiguration, IdentityInfoDataManager identityInfoDataManager) {
        super(idmEngineConfiguration, identityInfoDataManager);
    }


    public void deleteUserInfoByUserIdAndKey(string userId, string key) {
        IdentityInfoEntity identityInfoEntity = findUserInfoByUserIdAndKey(userId, key);
        if (identityInfoEntity !is null) {
            delete(identityInfoEntity);
        }
    }


    public void updateUserInfo(string userId, string userPassword, string type, string key, string value, string accountPassword, Map!(string, string) accountDetails) {
        byte[] storedPassword = null;
        if (accountPassword !is null) {
            storedPassword = encryptPassword(accountPassword, userPassword);
        }

        IdentityInfoEntity identityInfoEntity = findUserInfoByUserIdAndKey(userId, key);
        if (identityInfoEntity !is null) {
            // update
            identityInfoEntity.setValue(value);
            identityInfoEntity.setPasswordBytes(storedPassword);
            dataManager.update(identityInfoEntity);

            if (accountDetails is null) {
                accountDetails = new HashMap!(string,string)();
            }

            Set!string newKeys = new HashSet!string(accountDetails.byKey.array);
            List!IdentityInfoEntity identityInfoDetails = dataManager.findIdentityInfoDetails(identityInfoEntity.getId());
            foreach (IdentityInfoEntity identityInfoDetail ; identityInfoDetails) {
                string detailKey = identityInfoDetail.getKey();
                newKeys.remove(detailKey);
                string newDetailValue = accountDetails.get(detailKey);
                if (newDetailValue is null) {
                    dele(identityInfoDetail);
                } else {
                    // update detail
                    identityInfoDetail.setValue(newDetailValue);
                }
            }
            insertAccountDetails(identityInfoEntity, accountDetails, newKeys);

        } else {
            // insert
            identityInfoEntity = dataManager.create();
            identityInfoEntity.setUserId(userId);
            identityInfoEntity.setType(type);
            identityInfoEntity.setKey(key);
            identityInfoEntity.setValue(value);
            identityInfoEntity.setPasswordBytes(storedPassword);
            insert(identityInfoEntity, false);
            if (accountDetails !is null) {
                insertAccountDetails(identityInfoEntity, accountDetails, accountDetails.keySet());
            }
        }
    }

    protected void insertAccountDetails(IdentityInfoEntity identityInfoEntity, Map!(string, string) accountDetails, Set!string keys) {
        foreach (string newKey ; keys) {
            // insert detail
            IdentityInfoEntity identityInfoDetail = dataManager.create();
            identityInfoDetail.setParentId(identityInfoEntity.getId());
            identityInfoDetail.setKey(newKey);
            identityInfoDetail.setValue(accountDetails.get(newKey));
            insert(identityInfoDetail, false);
        }
    }

    protected byte[] encryptPassword(string accountPassword, string userPassword) {
        return accountPassword.getBytes();
    }

    protected string decryptPassword(byte[] storedPassword, string userPassword) {
        return new string(storedPassword);
    }


    public IdentityInfoEntity findUserInfoByUserIdAndKey(string userId, string key) {
        return dataManager.findUserInfoByUserIdAndKey(userId, key);
    }


    public List!IdentityInfoEntity findIdentityInfoByUserId(string userId) {
        return dataManager.findIdentityInfoByUserId(userId);
    }


    public List!string findUserInfoKeysByUserIdAndType(string userId, string type) {
        return dataManager.findUserInfoKeysByUserIdAndType(userId, type);
    }

}
