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
//import org.apache.commons.lang3.StringUtils;
//import flow.variable.service.api.types.VariableType;
//
///**
// * @author Tom Baeyens
// * @author Joram Barrez
// */
//class HistoricDetailVariableInstanceUpdateEntityImpl : HistoricDetailEntityImpl implements HistoricDetailVariableInstanceUpdateEntity {
//
//    private static final long serialVersionUID = 1L;
//
//    protected int revision;
//
//    protected string name;
//    protected VariableType variableType;
//
//    protected Long longValue;
//    protected Double doubleValue;
//    protected string textValue;
//    protected string textValue2;
//    protected ByteArrayRef byteArrayRef;
//
//    protected Object cachedValue;
//
//    public HistoricDetailVariableInstanceUpdateEntityImpl() {
//        this.detailType = "VariableUpdate";
//    }
//
//    override
//    public Object getPersistentState() {
//        // HistoricDetailVariableInstanceUpdateEntity is immutable, so always
//        // the same object is returned
//        return HistoricDetailVariableInstanceUpdateEntityImpl.class;
//    }
//
//    override
//    public Object getValue() {
//        if (!variableType.isCachable() || cachedValue is null) {
//            cachedValue = variableType.getValue(this);
//        }
//        return cachedValue;
//    }
//
//    override
//    public string getVariableTypeName() {
//        return (variableType !is null ? variableType.getTypeName() : null);
//    }
//
//    override
//    public int getRevisionNext() {
//        return revision + 1;
//    }
//
//    // byte array value /////////////////////////////////////////////////////////
//
//    override
//    public byte[] getBytes() {
//        if (byteArrayRef !is null) {
//            return byteArrayRef.getBytes();
//        }
//        return null;
//    }
//
//    override
//    public ByteArrayRef getByteArrayRef() {
//        return byteArrayRef;
//    }
//
//    override
//    public void setBytes(byte[] bytes) {
//        string byteArrayName = "hist.detail.var-" + name;
//        if (byteArrayRef is null) {
//            byteArrayRef = new ByteArrayRef();
//        }
//        byteArrayRef.setValue(byteArrayName, bytes);
//    }
//
//    // getters and setters ////////////////////////////////////////////////////////
//
//    override
//    public int getRevision() {
//        return revision;
//    }
//
//    override
//    public void setRevision(int revision) {
//        this.revision = revision;
//    }
//
//    override
//    public string getVariableName() {
//        return name;
//    }
//
//    override
//    public void setName(string name) {
//        this.name = name;
//    }
//
//    override
//    public string getName() {
//        return name;
//    }
//
//    override
//    public VariableType getVariableType() {
//        return variableType;
//    }
//
//    override
//    public void setVariableType(VariableType variableType) {
//        this.variableType = variableType;
//    }
//
//    override
//    public Long getLongValue() {
//        return longValue;
//    }
//
//    override
//    public void setLongValue(Long longValue) {
//        this.longValue = longValue;
//    }
//
//    override
//    public Double getDoubleValue() {
//        return doubleValue;
//    }
//
//    override
//    public void setDoubleValue(Double doubleValue) {
//        this.doubleValue = doubleValue;
//    }
//
//    override
//    public string getTextValue() {
//        return textValue;
//    }
//
//    override
//    public void setTextValue(string textValue) {
//        this.textValue = textValue;
//    }
//
//    override
//    public string getTextValue2() {
//        return textValue2;
//    }
//
//    override
//    public void setTextValue2(string textValue2) {
//        this.textValue2 = textValue2;
//    }
//
//    override
//    public Object getCachedValue() {
//        return cachedValue;
//    }
//
//    override
//    public void setCachedValue(Object cachedValue) {
//        this.cachedValue = cachedValue;
//    }
//
//    // common methods ///////////////////////////////////////////////////////////////
//
//    override
//    public string toString() {
//        StringBuilder sb = new StringBuilder();
//        sb.append("HistoricDetailVariableInstanceUpdateEntity[");
//        sb.append("id=").append(id);
//        sb.append(", name=").append(name);
//        sb.append(", type=").append(variableType !is null ? variableType.getTypeName() : "null");
//        if (longValue !is null) {
//            sb.append(", longValue=").append(longValue);
//        }
//        if (doubleValue !is null) {
//            sb.append(", doubleValue=").append(doubleValue);
//        }
//        if (textValue !is null) {
//            sb.append(", textValue=").append(StringUtils.abbreviate(textValue, 40));
//        }
//        if (textValue2 !is null) {
//            sb.append(", textValue2=").append(StringUtils.abbreviate(textValue2, 40));
//        }
//        if (byteArrayRef !is null && byteArrayRef.getId() !is null) {
//            sb.append(", byteArrayValueId=").append(byteArrayRef.getId());
//        }
//        sb.append("]");
//        return sb.toString();
//    }
//
//    override
//    public string getScopeId() {
//        return null;
//    }
//
//    override
//    public string getSubScopeId() {
//        return null;
//    }
//
//    override
//    public string getScopeType() {
//        return null;
//    }
//
//}
