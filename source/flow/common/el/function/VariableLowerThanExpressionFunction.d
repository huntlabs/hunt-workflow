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
//import java.util.Arrays;
//
//import flow.common.api.variable.VariableContainer;
//
///**
// * @author Joram Barrez
// */
//class VariableLowerThanExpressionFunction extends AbstractVariableComparatorExpressionFunction {
//
//    public VariableLowerThanExpressionFunction() {
//        super(Arrays.asList("lowerThan", "lessThan", "lt"), "lowerThan");
//    }
//
//    public static boolean lowerThan(VariableContainer variableContainer, String variableName, Object comparedValue) {
//        return compareVariableValue(variableContainer, variableName, comparedValue, OPERATOR.LT);
//    }
//
//}
