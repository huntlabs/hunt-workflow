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


class AppModel {

    protected string key;
    protected string name;
    protected string description;
    protected string theme;
    protected string icon;
    protected string usersAccess;
    protected string groupsAccess;

    public string getKey() {
        return key;
    }

    public void setKey(string key) {
        this.key = key;
    }

    public string getName() {
        return name;
    }

    public void setName(string name) {
        this.name = name;
    }

    public string getDescription() {
        return description;
    }

    public void setDescription(string description) {
        this.description = description;
    }

    public string getTheme() {
        return theme;
    }

    public void setTheme(string theme) {
        this.theme = theme;
    }

    public string getIcon() {
        return icon;
    }

    public void setIcon(string icon) {
        this.icon = icon;
    }

    public string getUsersAccess() {
        return usersAccess;
    }

    public void setUsersAccess(string usersAccess) {
        this.usersAccess = usersAccess;
    }

    public string getGroupsAccess() {
        return groupsAccess;
    }

    public void setGroupsAccess(string groupsAccess) {
        this.groupsAccess = groupsAccess;
    }
}
