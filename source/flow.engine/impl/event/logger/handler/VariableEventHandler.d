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


import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

import org.flowable.variable.api.event.FlowableVariableEvent;
import org.flowable.variable.api.types.VariableType;
import org.flowable.variable.service.impl.types.BooleanType;
import org.flowable.variable.service.impl.types.DateType;
import org.flowable.variable.service.impl.types.DoubleType;
import org.flowable.variable.service.impl.types.IntegerType;
import org.flowable.variable.service.impl.types.LongStringType;
import org.flowable.variable.service.impl.types.LongType;
import org.flowable.variable.service.impl.types.SerializableType;
import org.flowable.variable.service.impl.types.ShortType;
import org.flowable.variable.service.impl.types.StringType;
import org.flowable.variable.service.impl.types.UUIDType;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

/**
 * @author Joram Barrez
 */
abstract class VariableEventHandler extends AbstractDatabaseEventLoggerEventHandler {

    private static final Logger LOGGER = LoggerFactory.getLogger(VariableEventHandler.class);

    public static final string TYPE_BOOLEAN = "bool";
    public static final string TYPE_STRING = "string";
    public static final string TYPE_SHORT = "short";
    public static final string TYPE_INTEGER = "integer";
    public static final string TYPE_DOUBLE = "double";
    public static final string TYPE_LONG = "long";
    public static final string TYPE_DATE = "date";
    public static final string TYPE_UUID = "uuid";
    public static final string TYPE_JSON = "json";

    protected Map<string, Object> createData(FlowableVariableEvent variableEvent) {
        Map<string, Object> data = new HashMap<>();
        putInMapIfNotNull(data, Fields.NAME, variableEvent.getVariableName());
        putInMapIfNotNull(data, Fields.PROCESS_DEFINITION_ID, variableEvent.getProcessDefinitionId());
        putInMapIfNotNull(data, Fields.PROCESS_INSTANCE_ID, variableEvent.getProcessInstanceId());
        putInMapIfNotNull(data, Fields.EXECUTION_ID, variableEvent.getExecutionId());
        putInMapIfNotNull(data, Fields.VALUE, variableEvent.getVariableValue());

        VariableType variableType = variableEvent.getVariableType();
        if (variableType instanceof BooleanType) {

            putInMapIfNotNull(data, Fields.VALUE_BOOLEAN, (bool) variableEvent.getVariableValue());
            putInMapIfNotNull(data, Fields.VALUE, variableEvent.getVariableValue());
            putInMapIfNotNull(data, Fields.VARIABLE_TYPE, TYPE_BOOLEAN);

        } else if (variableType instanceof StringType || variableType instanceof LongStringType) {

            putInMapIfNotNull(data, Fields.VALUE_STRING, (string) variableEvent.getVariableValue());
            putInMapIfNotNull(data, Fields.VARIABLE_TYPE, TYPE_STRING);

        } else if (variableType instanceof ShortType) {

            Short value = (Short) variableEvent.getVariableValue();
            putInMapIfNotNull(data, Fields.VALUE_SHORT, value);
            putInMapIfNotNull(data, Fields.VARIABLE_TYPE, TYPE_SHORT);

            if (value != null) {
                putInMapIfNotNull(data, Fields.VALUE_INTEGER, value.intValue());
                putInMapIfNotNull(data, Fields.VALUE_LONG, value.longValue());
                putInMapIfNotNull(data, Fields.VALUE_DOUBLE, value.doubleValue());
            }

        } else if (variableType instanceof IntegerType) {

            Integer value = (Integer) variableEvent.getVariableValue();
            putInMapIfNotNull(data, Fields.VALUE_INTEGER, value);
            putInMapIfNotNull(data, Fields.VARIABLE_TYPE, TYPE_INTEGER);

            if (value != null) {
                putInMapIfNotNull(data, Fields.VALUE_LONG, value.longValue());
                putInMapIfNotNull(data, Fields.VALUE_DOUBLE, value.doubleValue());
            }

        } else if (variableType instanceof LongType) {

            Long value = (Long) variableEvent.getVariableValue();
            putInMapIfNotNull(data, Fields.VALUE_LONG, value);
            putInMapIfNotNull(data, Fields.VARIABLE_TYPE, TYPE_LONG);

            if (value != null) {
                putInMapIfNotNull(data, Fields.VALUE_DOUBLE, value.doubleValue());
            }

        } else if (variableType instanceof DoubleType) {

            Double value = (Double) variableEvent.getVariableValue();
            putInMapIfNotNull(data, Fields.VALUE_DOUBLE, value);
            putInMapIfNotNull(data, Fields.VARIABLE_TYPE, TYPE_DOUBLE);

            if (value != null) {
                putInMapIfNotNull(data, Fields.VALUE_INTEGER, value.intValue());
                putInMapIfNotNull(data, Fields.VALUE_LONG, value.longValue());
            }

        } else if (variableType instanceof DateType) {

            Date value = (Date) variableEvent.getVariableValue();
            putInMapIfNotNull(data, Fields.VALUE_DATE, value != null ? value.getTime() : null);
            putInMapIfNotNull(data, Fields.VARIABLE_TYPE, TYPE_DATE);

        } else if (variableType instanceof UUIDType) {

            string value = null;
            if (variableEvent.getVariableValue() instanceof UUID) {
                value = ((UUID) variableEvent.getVariableValue()).toString();
            } else {
                value = (string) variableEvent.getVariableValue();
            }

            putInMapIfNotNull(data, Fields.VALUE_UUID, value);
            putInMapIfNotNull(data, Fields.VALUE_STRING, value);
            putInMapIfNotNull(data, Fields.VARIABLE_TYPE, TYPE_UUID);

        } else if (variableType instanceof SerializableType || (variableEvent.getVariableValue() != null && (variableEvent.getVariableValue() instanceof Object))) {

            // Last try: serialize it to json
            ObjectMapper objectMapper = new ObjectMapper();
            try {
                string value = objectMapper.writeValueAsString(variableEvent.getVariableValue());
                putInMapIfNotNull(data, Fields.VALUE_JSON, value);
                putInMapIfNotNull(data, Fields.VARIABLE_TYPE, TYPE_JSON);
                putInMapIfNotNull(data, Fields.VALUE, value);
            } catch (JsonProcessingException e) {
                // Nothing to do about it
                LOGGER.debug("Could not serialize variable value {}", variableEvent.getVariableValue());
            }

        }

        return data;
    }

}
