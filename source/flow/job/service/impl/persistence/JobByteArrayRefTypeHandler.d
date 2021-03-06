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


//import java.sql.CallableStatement;
//import java.sql.PreparedStatement;
//import java.sql.ResultSet;
//import java.sql.SQLException;
//
//import org.apache.ibatis.type.JdbcType;
//import org.apache.ibatis.type.TypeHandler;
//import org.apache.ibatis.type.TypeReference;
//import flow.job.service.impl.persistence.entity.JobByteArrayRef;
//
///**
// * MyBatis TypeHandler for {@link JobByteArrayRef}.
// *
// * @author Marcus Klimstra (CGI)
// */
//class JobByteArrayRefTypeHandler extends TypeReference<JobByteArrayRef> implements TypeHandler<JobByteArrayRef> {
//
//    @Override
//    public void setParameter(PreparedStatement ps, int i, JobByteArrayRef parameter, JdbcType jdbcType) throws SQLException {
//        ps.setString(i, getValueToSet(parameter));
//    }
//
//    private string getValueToSet(JobByteArrayRef parameter) {
//        if (parameter is null) {
//            // Note that this should not happen: VariableByteArrayRefs should always be initialized.
//            return null;
//        }
//        return parameter.getId();
//    }
//
//    @Override
//    public JobByteArrayRef getResult(ResultSet rs, string columnName) throws SQLException {
//        string id = rs.getString(columnName);
//        return new JobByteArrayRef(id);
//    }
//
//    @Override
//    public JobByteArrayRef getResult(ResultSet rs, int columnIndex) throws SQLException {
//        string id = rs.getString(columnIndex);
//        return new JobByteArrayRef(id);
//    }
//
//    @Override
//    public JobByteArrayRef getResult(CallableStatement cs, int columnIndex) throws SQLException {
//        string id = cs.getString(columnIndex);
//        return new JobByteArrayRef(id);
//    }
//
//}
