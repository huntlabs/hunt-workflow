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


class Assignment extends BaseElement {

    protected string from;
    protected string to;

    public string getFrom() {
        return from;
    }

    public void setFrom(string from) {
        this.from = from;
    }

    public string getTo() {
        return to;
    }

    public void setTo(string to) {
        this.to = to;
    }

    @Override
    public Assignment clone() {
        Assignment clone = new Assignment();
        clone.setValues(this);
        return clone;
    }

    public void setValues(Assignment otherAssignment) {
        setFrom(otherAssignment.getFrom());
        setTo(otherAssignment.getTo());
    }
}
