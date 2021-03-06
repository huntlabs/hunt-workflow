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
//module flow.engine.impl.persistence.ByteArrayRefTypeHandler;
//
//import java.sql.CallableStatement;
//import java.sql.PreparedStatement;
//import java.sql.ResultSet;
//import java.sql.SQLException;
//
//import org.apache.ibatis.type.JdbcType;
//import org.apache.ibatis.type.TypeHandler;
//import org.apache.ibatis.type.TypeReference;
//import flow.engine.impl.persistence.entity.ByteArrayRef;
//
///**
// * MyBatis TypeHandler for {@link ByteArrayRef}.
// *
// * @author Marcus Klimstra (CGI)
// */
//class ByteArrayRefTypeHandler : TypeReference!ByteArrayRef implements TypeHandler!ByteArrayRef {
//
//    override
//    public void setParameter(PreparedStatement ps, int i, ByteArrayRef parameter, JdbcType jdbcType) throws SQLException {
//        ps.setString(i, getValueToSet(parameter));
//    }
//
//    private string getValueToSet(ByteArrayRef parameter) {
//        if (parameter is null) {
//            // Note that this should not happen: ByteArrayRefs should always be initialized.
//            return null;
//        }
//        return parameter.getId();
//    }
//
//    override
//    public ByteArrayRef getResult(ResultSet rs, string columnName) throws SQLException {
//        string id = rs.getString(columnName);
//        return new ByteArrayRef(id);
//    }
//
//    override
//    public ByteArrayRef getResult(ResultSet rs, int columnIndex) throws SQLException {
//        string id = rs.getString(columnIndex);
//        return new ByteArrayRef(id);
//    }
//
//    override
//    public ByteArrayRef getResult(CallableStatement cs, int columnIndex) throws SQLException {
//        string id = cs.getString(columnIndex);
//        return new ByteArrayRef(id);
//    }
//
//}
