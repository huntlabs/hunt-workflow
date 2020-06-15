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
module flow.engine.impl.form.FormTypes;


import hunt.collection.HashMap;
import hunt.collection.LinkedHashMap;
import hunt.collection.Map;

import flow.bpmn.model.FormProperty;
import flow.bpmn.model.FormValue;
import flow.common.api.FlowableIllegalArgumentException;
import flow.engine.form.AbstractFormType;
import flow.engine.impl.form.DateFormType;
import flow.engine.impl.form.EnumFormType;

/**
 * @author Tom Baeyens
 */
class FormTypes {

    protected Map!(string, AbstractFormType) formTypes ;//= new HashMap<>();

    this()
    {
      formTypes = new HashMap!(string, AbstractFormType);
    }

    public void addFormType(AbstractFormType formType) {
        formTypes.put(formType.getName(), formType);
    }

    public AbstractFormType parseFormPropertyType(FormProperty formProperty) {
        AbstractFormType formType = null;

        if ("date" == (formProperty.getType()) && (formProperty.getDatePattern() !is null && formProperty.getDatePattern().length != 0)) {
            formType = new DateFormType(formProperty.getDatePattern());

        } else if ("enum" == (formProperty.getType())) {
            // ACT-1023: Using linked hashmap to preserve the order in which the
            // entries are defined
            Map!(string, string) values = new LinkedHashMap!(string, string);
            foreach (FormValue formValue ; formProperty.getFormValues()) {
                values.put(formValue.getId(), formValue.getName());
            }
            formType = new EnumFormType(values);

        } else if (formProperty.getType() !is null && formProperty.getType().length != 0) {
            formType = formTypes.get(formProperty.getType());
            if (formType is null) {
                throw new FlowableIllegalArgumentException("unknown type '" ~ formProperty.getType() ~ "' " ~ formProperty.getId());
            }
        }
        return formType;
    }
}
