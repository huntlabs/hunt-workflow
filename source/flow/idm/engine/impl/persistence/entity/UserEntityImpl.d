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
module flow.idm.engine.impl.persistence.entity.UserEntityImpl;

import hunt.collection.HashMap;
import hunt.collection.Map;

import flow.idm.engine.impl.persistence.entity.ByteArrayRef;
import flow.common.db.HasRevision;
import flow.idm.api.Picture;
import flow.idm.engine.impl.persistence.entity.AbstractIdmEngineEntity;
import flow.idm.engine.impl.persistence.entity.UserEntity;
import hunt.entity;
import flow.common.persistence.entity.Entity;

/**
 * @author Tom Baeyens
 * @author Arkadiy Gornovoy
 * @author Joram Barrez
 */
@Table("ACT_ID_USER")
class UserEntityImpl :  AbstractIdmEngineEntity , Model,UserEntity, HasRevision {

   mixin MakeModel;

    @PrimaryKey
    @Column("ID_")
    string  id;

   @Column("FIRST_")
   string firstName;

   @Column("LAST_")
   string lastName;

  @Column("DISPLAY_NAME_")
   string displayName;

  @Column("EMAIL_")
   string email;

  @Column("PWD_")
   string password;


  @Column("TENANT_ID_")
   string tenantId;

  //  protected ByteArrayRef pictureByteArrayRef;

    this() {
    }

    override string getId()
    {
        return id;
    }

    override void setId(string id)
    {
        this.id = id;
    }

    public Object getPersistentState() {
        Map!(string, string) persistentState = new HashMap!(string, string)();
        persistentState.put("firstName", firstName);
        persistentState.put("lastName", lastName);
        persistentState.put("displayName", displayName);
        persistentState.put("email", email);
        persistentState.put("password", password);
        persistentState.put("tenantId", tenantId);

        //if (pictureByteArrayRef !is null) {
        //    persistentState.put("pictureByteArrayId", pictureByteArrayRef.getId());
        //}

        return cast(Object)persistentState;
    }

    public Picture getPicture() {
        //if (pictureByteArrayRef !is null && pictureByteArrayRef.getId() !is null) {
        //    return new Picture(pictureByteArrayRef.getBytes(), pictureByteArrayRef.getName());
        //}
        return null;
    }

    public void setPicture(Picture picture) {
        if (picture !is null) {
            savePicture(picture);
        } else {
            deletePicture();
        }
    }

    protected void savePicture(Picture picture) {
        //if (pictureByteArrayRef is null) {
        //    pictureByteArrayRef = new ByteArrayRef();
        //}
        //pictureByteArrayRef.setValue(picture.getMimeType(), picture.getBytes());
    }

    protected void deletePicture() {
        //if (pictureByteArrayRef !is null) {
        //    pictureByteArrayRef.dele();
        //}
    }

    public string getFirstName() {
        return firstName;
    }


    public void setFirstName(string firstName) {
        this.firstName = firstName;
    }


    public string getLastName() {
        return lastName;
    }


    public void setLastName(string lastName) {
        this.lastName = lastName;
    }


    public string getDisplayName() {
        return displayName;
    }


    public void setDisplayName(string displayName) {
        this.displayName = displayName;
    }


    public string getEmail() {
        return email;
    }


    public void setEmail(string email) {
        this.email = email;
    }


    public string getPassword() {
        return password;
    }


    public void setPassword(string password) {
        this.password = password;
    }


    public bool isPictureSet() {
      //  return pictureByteArrayRef !is null && pictureByteArrayRef.getId() !is null;
        return false;
    }


    public ByteArrayRef getPictureByteArrayRef() {
       // return pictureByteArrayRef;
        return null;
    }


    public string getTenantId() {
        return tenantId;
    }


    public void setTenantId(string tenantId) {
        this.tenantId = tenantId;
    }

    override
    string getIdPrefix()
    {
      return super.getIdPrefix;
    }

    override
    bool isInserted()
    {
      return super.isInserted();
    }

    override
    void setInserted(bool inserted)
    {
      return super.setInserted(inserted);
    }

    override
    bool isUpdated()
    {
      return super.isUpdated;
    }

    override
    void setUpdated(bool updated)
    {
      super.setUpdated(updated);
    }

    override
    bool isDeleted()
    {
      return super.isDeleted;
    }

    override
    void setDeleted(bool deleted)
    {
      super.setDeleted(deleted);
    }

    override
    Object getOriginalPersistentState()
    {
      return super.getOriginalPersistentState;
    }

    override
    void setOriginalPersistentState(Object persistentState)
    {
      super.setOriginalPersistentState(persistentState);
    }

    override
    void setRevision(int revision)
    {
      super.setRevision(revision);
    }

    override
    int getRevision()
    {
      return super.getRevision;
    }


    override
    int getRevisionNext()
    {
      return super.getRevisionNext;
    }

    int opCmp(Entity o)
    {
      return cast(int)(hashOf(this.id) - hashOf((cast(UserEntityImpl)o).getId));
    }
}
