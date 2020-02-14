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
 
module flow.task.service.delegate.BaseTaskListener;
 
 
 


import java.io.Serializable;

/**
 * @author Yvo Swillens
 */
public interface BaseTaskListener : Serializable {

    String EVENTNAME_CREATE = "create";
    String EVENTNAME_ASSIGNMENT = "assignment";
    String EVENTNAME_COMPLETE = "complete";
    String EVENTNAME_DELETE = "delete";

    /**
     * Not an actual event, used as a marker-value for {@link BaseTaskListener}s that should be called for all events, including {@link #EVENTNAME_CREATE} , {@link #EVENTNAME_ASSIGNMENT} and
     * {@link #EVENTNAME_COMPLETE} and {@link #EVENTNAME_DELETE}.
     */
    String EVENTNAME_ALL_EVENTS = "all";
}
