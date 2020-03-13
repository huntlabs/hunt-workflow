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
//import java.lang.reflect.Method;
//import java.util.List;
//import java.util.regex.Matcher;
//import java.util.regex.Pattern;
//
//import org.apache.commons.lang3.StringUtils;
//import flow.common.api.FlowableException;
//
///**
// * @author Joram Barrez
// */
//public abstract class AbstractFlowableShortHandExpressionFunction implements FlowableShortHandExpressionFunction {
//
//    protected String variableScopeName;
//    protected String functionName;
//    protected String prefix;
//    protected String localName;
//    protected Method method;
//
//    protected Pattern pattern;
//    protected String replacePattern;
//
//    /**
//     * @param variableScopeName The name of the scoped variable that would be added to the generated function
//     * @param functionNameOptions The list of function names, e.g. equals, eq
//     * @param functionName The function name to which all the others will be enhanced to
//     */
//    public AbstractFlowableShortHandExpressionFunction(String variableScopeName, List<String> functionNameOptions, String functionName) {
//
//        // Regex for expressions like ${variables:equals(myVar, 123)}
//        //
//        // - starts with function name (e.g. variables or vars or var), followed by :
//        // - followed by the function name (e.g. equals or eq)
//        // - followed by 0 or more whitespaces
//        // - followed by a parenthese
//        // - followed by 0 or more whitespaces
//        // - Optionally followed by a single our double quote
//        // - word group
//        // - Optionally followed by a single our double quote
//        // - followed by 0 or more whitespaces
//        // - followed by a comma or a closing parentheses
//        String matchingFunctionPrefix;
//        List<String> functionPrefixOptions = getFunctionPrefixOptions();
//        if (!functionPrefixOptions.isEmpty()) {
//            matchingFunctionPrefix = buildOrWordGroup(functionPrefixOptions) + ":";
//        } else {
//            // In case there are no function prefix options then use empty string
//            matchingFunctionPrefix = "";
//        }
//        this.pattern = Pattern.compile(matchingFunctionPrefix
//                + buildOrWordGroup(functionNameOptions)
//                + "\\s*\\(\\s*'?\"?(.*?)'?\"?\\s*"
//                + (isMultiParameterFunction() ? "," : "\\)"));
//
//        this.prefix = getFinalFunctionPrefix();
//
//        StringBuilder replacePatternBuilder = new StringBuilder();
//        if (StringUtils.isNotEmpty(this.prefix)) {
//            replacePatternBuilder.append(this.prefix).append(":");
//        }
//
//        replacePatternBuilder.append(functionName);
//
//        if (isNoParameterMethod()) {
//            replacePatternBuilder.append('(').append(variableScopeName);
//        } else if (!functionPrefixOptions.isEmpty()) {
//            replacePatternBuilder.append('(').append(variableScopeName).append(",'$3'"); // 3th word group, the parameter: prefix and function name are two first groups
//        } else {
//            replacePatternBuilder.append('(').append(variableScopeName).append(",'$2'"); // 2th word group, the parameter: function name is the first group, there are no prefix options
//        }
//
//        if (isMultiParameterFunction()) {
//            replacePatternBuilder.append(',');
//        } else {
//            replacePatternBuilder.append(')');
//        }
//
//        this.replacePattern = replacePatternBuilder.toString();
//
//        this.localName = functionName;
//
//        // By convention, the implementing class should have one method with the same name
//        this.method = findMethod();
//    }
//
//    protected Method findMethod() {
//        Method[] methods = this.getClass().getMethods();
//        for (Method method : methods) {
//            if (method.getName().equals(localName)) {
//                return method;
//            }
//        }
//        throw new FlowableException("Programmatic error: could not find method " + localName + " on class " + this.getClass());
//    }
//
//    protected abstract List<String> getFunctionPrefixOptions();
//
//    protected abstract String getFinalFunctionPrefix();
//
//    protected abstract boolean isMultiParameterFunction();
//
//    /**
//     * Override and return true in case the method call does not have any parameters. E.g. ${prefix:someFunction()}
//     */
//    protected boolean isNoParameterMethod() {
//        return false;
//    }
//
//    protected String buildOrWordGroup(List<String> options) {
//        StringBuilder strb = new StringBuilder();
//        strb.append("(");
//        strb.append(String.join("|", options));
//        strb.append(")");
//        return strb.toString();
//    }
//
//    @Override
//    public String enhance(String expressionText) {
//        Matcher matcher = pattern.matcher(expressionText);
//        if (matcher.find()) {
//            return matcher.replaceAll(replacePattern);
//        }
//        return expressionText;
//    }
//
//    @Override
//    public String localName() {
//        return localName;
//    }
//
//    @Override
//    public String prefix() {
//        return prefix;
//    }
//
//    @Override
//    public Method functionMethod() {
//        return method;
//    }
//
//}
