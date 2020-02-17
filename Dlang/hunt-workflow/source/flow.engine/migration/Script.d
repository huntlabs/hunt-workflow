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


/**
 * @author martin.grofcik
 */
class Script {
    protected string script;
    protected string language;

    public Script() {
    }

    public Script(string language, string script) {
        this.script = script;
        this.language = language;
    }

    public string getScript() {
        return script;
    }
    public void setScript(string script) {
        this.script = script;
    }
    public string getLanguage() {
        return language;
    }
    public void setLanguage(string language) {
        this.language = language;
    }
}
