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

module flow.task.api.TaskInfoQueryWrapper;

 import flow.task.api.TaskInfoQuery;

/**
 * This is a helper class to help you work with the {@link TaskInfoQuery}, without having to care about the awful generics.
 *
 * Example usage:
 *
 * TaskInfoQueryWrapper taskInfoQueryWrapper = new TaskInfoQueryWrapper(taskService.createTaskQuery()); List<? extends TaskInfo> taskInfos = taskInfoQueryWrapper.getTaskInfoQuery().or()
 * .taskNameLike("%task%") .taskDescriptionLike("%blah%"); .endOr() .list();
 *
 * First line can be switched to TaskInfoQueryWrapper taskInfoQueryWrapper = new TaskInfoQueryWrapper(historyService.createTaskQuery()); and the same methods can be used on the result.
 *
 * @author Joram Barrez
 */
class TaskInfoQueryWrapper {

   // protected TaskInfoQuery<? extends TaskInfoQuery<?, ?>, ? extends TaskInfo> taskInfoQuery;
    protected  Object taskInfoQuery;

    //public TaskInfoQueryWrapper(TaskInfoQuery<? extends TaskInfoQuery<?, ?>, ? extends TaskInfo> taskInfoQuery) {
    //    this.taskInfoQuery = taskInfoQuery;
    //}

    this(Object taskInfoQuery) {
        this.taskInfoQuery = taskInfoQuery;
    }

    //public TaskInfoQuery<? extends TaskInfoQuery<?, ?>, ? extends TaskInfo> getTaskInfoQuery() {
    //    return taskInfoQuery;
    //}

      public Object getTaskInfoQuery() {
        return taskInfoQuery;
    }

    //public void setTaskInfoQuery(TaskInfoQuery<? extends TaskInfoQuery<?, ?>, ? extends TaskInfo> taskInfoQuery) {
    //    this.taskInfoQuery = taskInfoQuery;
    //}

      public void setTaskInfoQuery(Object taskInfoQuery) {
        this.taskInfoQuery = taskInfoQuery;
    }

}
