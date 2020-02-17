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


class DataStore extends BaseElement {

    protected string name;
    protected string dataState;
    protected string itemSubjectRef;

    public string getName() {
        return name;
    }

    public void setName(string name) {
        this.name = name;
    }

    public string getDataState() {
        return dataState;
    }

    public void setDataState(string dataState) {
        this.dataState = dataState;
    }

    public string getItemSubjectRef() {
        return itemSubjectRef;
    }

    public void setItemSubjectRef(string itemSubjectRef) {
        this.itemSubjectRef = itemSubjectRef;
    }

    @Override
    public DataStore clone() {
        DataStore clone = new DataStore();
        clone.setValues(this);
        return clone;
    }

    public void setValues(DataStore otherElement) {
        super.setValues(otherElement);
        setName(otherElement.getName());
        setDataState(otherElement.getDataState());
        setItemSubjectRef(otherElement.getItemSubjectRef());
    }

}
