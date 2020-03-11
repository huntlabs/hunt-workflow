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

module flow.event.registry.model.ChannelModel;



class ChannelModel {

    protected string key;
    protected string category;
    protected string name;
    protected string description;

    // inbound or outbound
    protected string channelType;

    // jms, rabbitmq, kafka etc
    protected string type;

    public string getKey() {
        return key;
    }

    public void setKey(string key) {
        this.key = key;
    }

    public string getCategory() {
        return category;
    }

    public void setCategory(string category) {
        this.category = category;
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

    public string getChannelType() {
        return channelType;
    }

    public void setChannelType(string channelType) {
        this.channelType = channelType;
    }

    public string getType() {
        return type;
    }

    public void setType(string type) {
        this.type = type;
    }

}
