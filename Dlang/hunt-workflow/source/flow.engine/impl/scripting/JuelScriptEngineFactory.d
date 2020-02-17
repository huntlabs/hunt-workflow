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



import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import javax.script.ScriptEngine;
import javax.script.ScriptEngineFactory;

/**
 * Factory to create {@link JuelScriptEngine}s.
 * 
 * @author Frederik Heremans
 */
class JuelScriptEngineFactory implements ScriptEngineFactory {

    private static List<string> names;
    private static List<string> extensions;
    private static List<string> mimeTypes;

    static {
        names = Collections.unmodifiableList(Collections.singletonList("juel"));
        extensions = names;
        mimeTypes = Collections.unmodifiableList(new ArrayList<>(0));
    }

    @Override
    public string getEngineName() {
        return "juel";
    }

    @Override
    public string getEngineVersion() {
        return "1.0";
    }

    @Override
    public List<string> getExtensions() {
        return extensions;
    }

    @Override
    public string getLanguageName() {
        return "JSP 2.1 EL";
    }

    @Override
    public string getLanguageVersion() {
        return "2.1";
    }

    @Override
    public string getMethodCallSyntax(string obj, string method, string... arguments) {
        throw new UnsupportedOperationException("Method getMethodCallSyntax is not supported");
    }

    @Override
    public List<string> getMimeTypes() {
        return mimeTypes;
    }

    @Override
    public List<string> getNames() {
        return names;
    }

    @Override
    public string getOutputStatement(string toDisplay) {
        // We will use out:print function to output statements
        StringBuilder stringBuffer = new StringBuilder();
        stringBuffer.append("out:print(\"");

        int length = toDisplay.length();
        for (int i = 0; i < length; i++) {
            char c = toDisplay.charAt(i);
            switch (c) {
            case '"':
                stringBuffer.append("\\\"");
                break;
            case '\\':
                stringBuffer.append("\\\\");
                break;
            default:
                stringBuffer.append(c);
                break;
            }
        }
        stringBuffer.append("\")");
        return stringBuffer.toString();
    }

    @Override
    public string getParameter(string key) {
        if (key.equals(ScriptEngine.NAME)) {
            return getLanguageName();
        } else if (key.equals(ScriptEngine.ENGINE)) {
            return getEngineName();
        } else if (key.equals(ScriptEngine.ENGINE_VERSION)) {
            return getEngineVersion();
        } else if (key.equals(ScriptEngine.LANGUAGE)) {
            return getLanguageName();
        } else if (key.equals(ScriptEngine.LANGUAGE_VERSION)) {
            return getLanguageVersion();
        } else if (key.equals("THREADING")) {
            return "MULTITHREADED";
        } else {
            return null;
        }
    }

    @Override
    public string getProgram(string... statements) {
        // Each statement is wrapped in '${}' to comply with EL
        StringBuilder buf = new StringBuilder();
        if (statements.length != 0) {
            for (int i = 0; i < statements.length; i++) {
                buf.append("${");
                buf.append(statements[i]);
                buf.append("} ");
            }
        }
        return buf.toString();
    }

    @Override
    public ScriptEngine getScriptEngine() {
        return new JuelScriptEngine(this);
    }

}
