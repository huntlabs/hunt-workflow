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

module flow.bpmn.model.DataGrid;

import hunt.collection.ArrayList;
import hunt.collection.List;
import flow.bpmn.model.ComplexDataType;
import flow.bpmn.model.DataGridRow;

/**
 * @author Tijs Rademakers
 */
class DataGrid : ComplexDataType {

    protected List!DataGridRow rows ;//= new ArrayList<>();

    this()
    {
      rows = new ArrayList!DataGridRow;
    }

    public List!DataGridRow getRows() {
        return rows;
    }

    public void setRows(List!DataGridRow rows) {
        this.rows = rows;
    }

    public DataGrid clone() {
        DataGrid clone = new DataGrid();
        clone.setValues(this);
        return clone;
    }

    public void setValues(DataGrid otherGrid) {
        rows = new ArrayList!DataGridRow();
        if (otherGrid.getRows() !is null && !otherGrid.getRows().isEmpty()) {
            foreach (DataGridRow row ; otherGrid.getRows()) {
                rows.add(row.clone());
            }
        }
    }
}
