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

module flow.common.api.FlowableWrongDbException;


import flow.common.api.FlowableException;

/**
 * Exception that is thrown when the Flowable engine discovers a mismatch between the database schema version and the engine version.
 *
 * The check is done when the engine is created in {@link ProcessEngineBuilder#buildProcessEngine()}.
 *
 * @author Tom Baeyens
 */
class FlowableWrongDbException : FlowableException {

    private static  long serialVersionUID = 1L;

    string libraryVersion;
    string dbVersion;

    this(string libraryVersion, string dbVersion) {
        super(
                "version mismatch: library version is '"
                        ~= libraryVersion
                        ~= "', db version is "
                        ~= dbVersion
                        ~= " Hint: Set <property name=\"databaseSchemaUpdate\" to value=\"true\" or value=\"create-drop\" (use create-drop for testing only!) in bean processEngineConfiguration in flowable.cfg.xml for automatic schema creation");
        this.libraryVersion = libraryVersion;
        this.dbVersion = dbVersion;
    }

    /**
     * The version of the Flowable library used.
     */
    public string getLibraryVersion() {
        return libraryVersion;
    }

    /**
     * The version of the Flowable library that was used to create the database schema.
     */
    public string getDbVersion() {
        return dbVersion;
    }
}
