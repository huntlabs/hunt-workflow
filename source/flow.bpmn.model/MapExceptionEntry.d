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
 * @author Saeid Mirzaei
 */

class MapExceptionEntry {

    protected string errorCode;
    protected string className;
    protected bool andChildren;
    protected string rootCause;

    public MapExceptionEntry(){
        
    }

    public MapExceptionEntry(string errorCode, string className, bool andChildren, string rootCause) {
        this.errorCode = errorCode;
        this.className = className;
        this.andChildren = andChildren;
        this.rootCause = rootCause;
    }

    public string getErrorCode() {
        return errorCode;
    }

    public void setErrorCode(string errorCode) {
        this.errorCode = errorCode;
    }

    public string getClassName() {
        return className;
    }

    public void setClassName(string className) {
        this.className = className;
    }

    public bool isAndChildren() {
        return andChildren;
    }

    public void setAndChildren(bool andChildren) {
        this.andChildren = andChildren;
    }

    public string getRootCause() {
        return rootCause;
    }

    public void setRootCause(string rootCause) {
        this.rootCause = rootCause;
    }

}
