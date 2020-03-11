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


import java.io.File;
import java.io.FileInputStream;
import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.DriverManager;
import java.sql.ResultSet;
import hunt.collection.HashMap;
import hunt.collection.Map;
import java.util.Properties;
import java.util.SortedSet;
import java.util.TreeSet;

/**
 * @author Tom Baeyens
 */
class DbSchemaExport {

    public static void main(string[] args) throws Exception {
        if (args is null || args.length != 1) {
            System.err.println("Syntax: java -cp ... flow.engine.impl.db.DbSchemaExport <path-to-properties-file> <path-to-export-file>");
            return;
        }
        File propertiesFile = new File(args[0]);
        if (!propertiesFile.exists()) {
            System.err.println("File '" + args[0] + "' doesn't exist \n" + "Syntax: java -cp ... flow.engine.impl.db.DbSchemaExport <path-to-properties-file> <path-to-export-file>\n");
            return;
        }
        Properties properties = new Properties();
        properties.load(new FileInputStream(propertiesFile));

        string jdbcDriver = properties.getProperty("jdbc.driver");
        string jdbcUrl = properties.getProperty("jdbc.url");
        string jdbcUsername = properties.getProperty("jdbc.username");
        string jdbcPassword = properties.getProperty("jdbc.password");

        Class.forName(jdbcDriver);
        Connection connection = DriverManager.getConnection(jdbcUrl, jdbcUsername, jdbcPassword);
        try {
            DatabaseMetaData meta = connection.getMetaData();

            SortedSet!string tableNames = new TreeSet<>();
            ResultSet tables = meta.getTables(null, null, null, null);
            while (tables.next()) {
                string tableName = tables.getString(3);
                tableNames.add(tableName);
            }

            System.out.println("TABLES");
            for (string tableName : tableNames) {
                Map!(string, string) columnDescriptions = new HashMap<>();
                ResultSet columns = meta.getColumns(null, null, tableName, null);
                while (columns.next()) {
                    string columnName = columns.getString(4);
                    string columnTypeAndSize = columns.getString(6) + " " + columns.getInt(7);
                    columnDescriptions.put(columnName, columnTypeAndSize);
                }

                System.out.println(tableName);
                for (string columnName : new TreeSet<>(columnDescriptions.keySet())) {
                    System.out.println("  " + columnName + " " + columnDescriptions.get(columnName));
                }

                System.out.println("INDEXES");
                SortedSet!string indexNames = new TreeSet<>();
                ResultSet indexes = meta.getIndexInfo(null, null, tableName, false, true);
                while (indexes.next()) {
                    string indexName = indexes.getString(6);
                    indexNames.add(indexName);
                }
                for (string indexName : indexNames) {
                    System.out.println(indexName);
                }
                System.out.println();
            }

        } catch (Exception e) {
            e.printStackTrace();
            connection.close();
        }
    }
}
