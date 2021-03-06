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

module flow.engine.impl.bpmn.data.ItemDefinition;

import flow.engine.impl.bpmn.data.ItemKind;
import flow.engine.impl.bpmn.data.StructureDefinition;
import flow.engine.impl.bpmn.data.ItemInstance;
/**
 * Implementation of the BPMN 2.0 'itemDefinition'
 *
 * @author Esteban Robles Luna
 */
class ItemDefinition {

    protected string id;

    protected StructureDefinition structure;

    protected bool _isCollection;

    protected ItemKind itemKind;

    this() {
        this._isCollection = false;
        this.itemKind = ItemKind.Information;
    }

    this(string id, StructureDefinition structure) {
        this();
        this.id = id;
        this.structure = structure;
    }

    public ItemInstance createInstance() {
        return new ItemInstance(this, this.structure.createInstance());
    }

    public StructureDefinition getStructureDefinition() {
        return this.structure;
    }

    public bool isCollection() {
        return _isCollection;
    }

    public void setCollection(bool isCollection) {
        this._isCollection = isCollection;
    }

    public ItemKind getItemKind() {
        return itemKind;
    }

    public void setItemKind(ItemKind itemKind) {
        this.itemKind = itemKind;
    }

    public string getId() {
        return this.id;
    }
}
