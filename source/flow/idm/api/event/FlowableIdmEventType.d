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
//          Copyright linse 2020.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)}

module flow.idm.api.event.FlowableIdmEventType;




import std.array;
import hunt.collection.ArrayList;
import hunt.collection.List;
import hunt.Exceptions;
import flow.common.api.deleg.event.FlowableEventType;
import hunt.Enum;
import std.concurrency : initOnce;
/**
 * Enumeration containing all possible types of {@link FlowableIdmEvent}s.
 *
 * @author Frederik Heremans
 *
 */
class FlowableIdmEventType : AbstractEnum!FlowableIdmEventType,  FlowableEventType {

   static FlowableIdmEventType[] vs;

  /**
     * New entity is created.
     */
    this(string name, int val)
    {
        super(name,val);
    }


    static FlowableIdmEventType[] values()
    {
        if (vs.length == 0)
        {
            vs ~= ENTITY_CREATED;
            vs ~= ENTITY_INITIALIZED;
            vs ~= ENTITY_UPDATED;
            vs ~= ENTITY_DELETED;
            vs ~= CUSTOM;
            vs ~= ENGINE_CREATED;
            vs ~= ENGINE_CLOSED;
            vs ~= MEMBERSHIP_CREATED;
            vs ~= MEMBERSHIP_DELETED;
            vs ~= MEMBERSHIPS_DELETED;
        }
        return vs;
    }

    static FlowableIdmEventType  ENTITY_CREATED() {
      __gshared FlowableIdmEventType  inst;
      return initOnce!inst(new FlowableIdmEventType("ENTITY_CREATED" , 0));
    }

    //string name()
    //{
    //    return super.name();
    //}
    /**
     * New entity has been created and all child-entities that are created as a result of the creation of this particular entity are also created and initialized.
     */
    static FlowableIdmEventType  ENTITY_INITIALIZED() {
      __gshared FlowableIdmEventType  inst;
      return initOnce!inst(new FlowableIdmEventType("ENTITY_INITIALIZED" , 1));
    }
    /**
     * Existing entity us updated.
     */
    static FlowableIdmEventType  ENTITY_UPDATED() {
      __gshared FlowableIdmEventType  inst;
      return initOnce!inst(new FlowableIdmEventType("ENTITY_UPDATED" , 2));
    }
    /**
     * Existing entity is deleted.
     */
    static FlowableIdmEventType  ENTITY_DELETED() {
      __gshared FlowableIdmEventType  inst;
      return initOnce!inst(new FlowableIdmEventType("ENTITY_DELETED" ,3));
    }
    /**
     * An event type to be used by custom events. These types of events are never thrown by the engine itself, only be an external API call to dispatch an event.
     */
    static FlowableIdmEventType  CUSTOM() {
      __gshared FlowableIdmEventType  inst;
      return initOnce!inst(new FlowableIdmEventType("CUSTOM" ,4));
    }
    /**
     * The process-engine that dispatched this event has been created and is ready for use.
     */
    static FlowableIdmEventType  ENGINE_CREATED() {
      __gshared FlowableIdmEventType  inst;
      return initOnce!inst(new FlowableIdmEventType("ENGINE_CREATED" ,5));
    }
    /**
     * The process-engine that dispatched this event has been closed and cannot be used anymore.
     */
    static FlowableIdmEventType  ENGINE_CLOSED() {
      __gshared FlowableIdmEventType  inst;
      return initOnce!inst(new FlowableIdmEventType("ENGINE_CLOSED" ,6));
    }
    /**
     * A new membership has been created.
     */
    static FlowableIdmEventType  MEMBERSHIP_CREATED() {
      __gshared FlowableIdmEventType  inst;
      return initOnce!inst(new FlowableIdmEventType("MEMBERSHIP_CREATED" ,7));
    }
    /**
     * A single membership has been deleted.
     */
    static FlowableIdmEventType  MEMBERSHIP_DELETED() {
      __gshared FlowableIdmEventType  inst;
      return initOnce!inst(new FlowableIdmEventType("MEMBERSHIP_DELETED" ,8));
    }
    /**
     * All memberships in the related group have been deleted. No individual {@link #MEMBERSHIP_DELETED} events will be dispatched due to possible performance reasons. The event is dispatched before
     * the memberships are deleted, so they can still be accessed in the dispatch method of the listener.
     */
    static FlowableIdmEventType  MEMBERSHIPS_DELETED() {
        __gshared FlowableIdmEventType  inst;
        return initOnce!inst(new FlowableIdmEventType("MEMBERSHIPS_DELETED" ,9));
    }

        static FlowableIdmEventType[]  EMPTY_ARRAY() {
            __gshared FlowableIdmEventType [] inst;
            return initOnce!inst(inst);
        }
    /**
     * @param string
     *            the string containing a comma-separated list of event-type names
     * @return a list of {@link FlowableIdmEventType} based on the given list.
     * @throws IllegalArgumentException
     *             when one of the given string is not a valid type name
     */
    public static FlowableIdmEventType[] getTypesFromString(string str) {
        //implementationMissing(false);
        List!FlowableIdmEventType result = new ArrayList!FlowableIdmEventType();
        if (str !is null && str.length != 0) {
            string[] split = str.split(",");
            foreach (string typeName ; split) {
                bool found = false;
                foreach (FlowableIdmEventType type ; values()) {
                    if (typeName == (type.name())) {
                        result.add(type);
                        found = true;
                        break;
                    }
                }
                if (!found) {
                    throw new IllegalArgumentException("Invalid event-type: " ~ typeName);
                }
            }
        }
        return result.toArray();
        //return result.toArray(EMPTY_ARRAY);
    }

     int opCmp(FlowableEventType o)
     {
          return cast(int)(hashOf(this.name()) - hashOf((cast(FlowableIdmEventType)o).name()));
     }
}
