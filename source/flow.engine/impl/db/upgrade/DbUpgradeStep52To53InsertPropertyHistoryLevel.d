///* Licensed under the Apache License, Version 2.0 (the "License");
// * you may not use this file except in compliance with the License.
// * You may obtain a copy of the License at
// *
// *      http://www.apache.org/licenses/LICENSE-2.0
// *
// * Unless required by applicable law or agreed to in writing, software
// * distributed under the License is distributed on an "AS IS" BASIS,
// * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// * See the License for the specific language governing permissions and
// * limitations under the License.
// */
//
//
//
//import flow.common.db.DbUpgradeStep;
//
///**
// * @author Tom Baeyens
// */
//class DbUpgradeStep52To53InsertPropertyHistoryLevel implements DbUpgradeStep {
//
//    override
//    public void execute() throws Exception {
//        // As of 5.11, the history-setting is no longer stored in the database,
//        // so inserting it in this upgrade and removing
//        // in in a 5.10->5.11 upgrade is useless...
//
//        // int historyLevel =
//        // CommandContextUtil.getProcessEngineConfiguration().getHistoryLevel();
//        // PropertyEntity property = new PropertyEntity("historyLevel",
//        // Integer.toString(historyLevel));
//        // dbSqlSession.insert(property);
//    }
//
//}
