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

module flow.event.registry.tenantdetector.InboundEventStaticTenantDetector;

import flow.event.registry.api.InboundEventTenantDetector;

/**
 * @author Joram Barrez
 */
class InboundEventStaticTenantDetector(T) : InboundEventTenantDetector!T {

    protected string staticTenantId;

    this(string staticTenantId) {
        this.staticTenantId = staticTenantId;
    }

    public string detectTenantId(T event) {
        return staticTenantId;
    }

    public string getStaticTenantId() {
        return staticTenantId;
    }
}
