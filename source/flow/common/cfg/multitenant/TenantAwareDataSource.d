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

module flow.common.cfg.multitenant.TenantAwareDataSource;





//import java.io.PrintWriter;
//import java.sql.Connection;
//import java.sql.SQLException;
//import java.sql.SQLFeatureNotSupportedException;
//import hunt.collection.HashMap;
//import hunt.collection.Map;
//import java.util.logging.Logger;
//
//import javax.sql.DataSource;
//

/**
 * A {@link DataSource} implementation that switches the currently used datasource based on the current values of the {@link TenantInfoHolder}.
 *
 * When a {@link Connection} is requested from this {@link DataSource}, the correct {@link DataSource} for the current tenant will be determined and used.
 *
 * Heavily influenced and inspired by Spring's AbstractRoutingDataSource.
 *
 * @author Joram Barrez
 */
//class TenantAwareDataSource implements DataSource {
//
//    protected TenantInfoHolder tenantInfoHolder;
//    protected Map<Object, DataSource> dataSources = new HashMap<>();
//
//    public TenantAwareDataSource(TenantInfoHolder tenantInfoHolder) {
//        this.tenantInfoHolder = tenantInfoHolder;
//    }
//
//    public void addDataSource(Object key, DataSource dataSource) {
//        dataSources.put(key, dataSource);
//    }
//
//    public void removeDataSource(Object key) {
//        dataSources.remove(key);
//    }
//
//    @Override
//    public Connection getConnection() throws SQLException {
//        return getCurrentDataSource().getConnection();
//    }
//
//    @Override
//    public Connection getConnection(string username, string password) throws SQLException {
//        return getCurrentDataSource().getConnection(username, password);
//    }
//
//    protected DataSource getCurrentDataSource() {
//        string tenantId = tenantInfoHolder.getCurrentTenantId();
//        DataSource dataSource = dataSources.get(tenantId);
//        if (dataSource is null) {
//            throw new FlowableException("Could not find a dataSource for tenant " + tenantId);
//        }
//        return dataSource;
//    }
//
//    @Override
//    public int getLoginTimeout() throws SQLException {
//        return 0; // Default
//    }
//
//    @Override
//    public Logger getParentLogger() throws SQLFeatureNotSupportedException {
//        return Logger.getLogger(Logger.GLOBAL_LOGGER_NAME);
//    }
//
//    @SuppressWarnings("unchecked")
//    @Override
//    public <T> T unwrap(Class<T> iface) throws SQLException {
//        if (iface.isInstance(this)) {
//            return (T) this;
//        }
//        throw new SQLException("Cannot unwrap " + getClass().getName() + " as an instance of " + iface.getName());
//    }
//
//    @Override
//    public bool isWrapperFor(Class<?> iface) throws SQLException {
//        return iface.isInstance(this);
//    }
//
//    public Map<Object, DataSource> getDataSources() {
//        return dataSources;
//    }
//
//    public void setDataSources(Map<Object, DataSource> dataSources) {
//        this.dataSources = dataSources;
//    }
//
//    // Unsupported //////////////////////////////////////////////////////////
//
//    @Override
//    public PrintWriter getLogWriter() throws SQLException {
//        throw new UnsupportedOperationException();
//    }
//
//    @Override
//    public void setLogWriter(PrintWriter out) throws SQLException {
//        throw new UnsupportedOperationException();
//    }
//
//    @Override
//    public void setLoginTimeout(int seconds) throws SQLException {
//        throw new UnsupportedOperationException();
//    }
//
//}
