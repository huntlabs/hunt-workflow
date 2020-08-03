module flow.common.api.DataManger;

import flow.common.persistence.entity.Entity;
import hunt.entity.EntityManager;
interface DataManger {
   void insertTrans(Entity entity , EntityManager db);
   TypeInfo getTypeInfo();
   void deleteTrans(Entity entity , EntityManager db);
}
