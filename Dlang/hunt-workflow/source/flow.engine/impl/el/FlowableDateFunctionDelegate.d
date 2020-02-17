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



import java.lang.reflect.Method;

import flow.common.el.AbstractFlowableFunctionDelegate;

/**
 * A date function mapper that can be used in EL expressions
 * 
 * @author Tijs Rademakers
 */
class FlowableDateFunctionDelegate extends AbstractFlowableFunctionDelegate {

    @Override
    public string prefix() {
        return "date";
    }

    @Override
    public string localName() {
        return "format";
    }

    @Override
    class<?> functionClass() {
        return DateUtil.class;
    }

    @Override
    public Method functionMethod() {
        return getSingleObjectParameterMethod();
    }

}
