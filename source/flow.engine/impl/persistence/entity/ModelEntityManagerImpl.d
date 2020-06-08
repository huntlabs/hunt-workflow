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

module flow.engine.impl.persistence.entity.ModelEntityManagerImpl;

import hunt.collection.List;
import hunt.collection.Map;

import flow.engine.impl.ModelQueryImpl;
import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
import flow.engine.impl.persistence.entity.data.ModelDataManager;
import flow.engine.repository.Model;
import flow.engine.impl.persistence.entity.AbstractProcessEngineEntityManager;
import flow.engine.impl.persistence.entity.ModelEntity;
import flow.engine.impl.persistence.entity.ModelEntityManager;
import hunt.time.LocalDateTime;
import flow.engine.impl.persistence.entity.ByteArrayRef;
/**
 * @author Tijs Rademakers
 * @author Joram Barrez
 */
class ModelEntityManagerImpl
    : AbstractProcessEngineEntityManager!(ModelEntity, ModelDataManager)
    , ModelEntityManager {

    this(ProcessEngineConfigurationImpl processEngineConfiguration, ModelDataManager modelDataManager) {
        super(processEngineConfiguration, modelDataManager);
    }

    override
    public ModelEntity findById(string entityId) {
        return dataManager.findById(entityId);
    }

    override
    public void insert(ModelEntity model) {
        model.setCreateTime(LocalDateTime.now());
        model.setLastUpdateTime(LocalDateTime.now());

        super.insert(model);
    }

    override
    public void updateModel(ModelEntity updatedModel) {
        updatedModel.setLastUpdateTime(LocalDateTime.now());
        update(updatedModel);
    }

    override
    public void dele(string modelId) {
        ModelEntity modelEntity = findById(modelId);
        super.dele(modelEntity);
        deleteEditorSource(modelEntity);
        deleteEditorSourceExtra(modelEntity);
    }

    override
    public void insertEditorSourceForModel(string modelId, byte[] modelSource) {
        ModelEntity model = findById(modelId);
        if (model !is null) {
            ByteArrayRef rf = new ByteArrayRef(model.getEditorSourceValueId());
            rf.setValue("source", modelSource);

            if (model.getEditorSourceValueId().length == 0) {
                model.setEditorSourceValueId(rf.getId());
                updateModel(model);
            }
        }
    }

    override
    public void deleteEditorSource(ModelEntity model) {
        if (model.getEditorSourceValueId().length != 0) {
            ByteArrayRef rf = new ByteArrayRef(model.getEditorSourceValueId());
            rf.dele();
        }
    }

    override
    public void deleteEditorSourceExtra(ModelEntity model) {
        if (model.getEditorSourceExtraValueId().length != 0) {
            ByteArrayRef rf = new ByteArrayRef(model.getEditorSourceExtraValueId());
            rf.dele();
        }
    }

    override
    public void insertEditorSourceExtraForModel(string modelId, byte[] modelSource) {
        ModelEntity model = findById(modelId);
        if (model !is null) {
            ByteArrayRef rf = new ByteArrayRef(model.getEditorSourceExtraValueId());
            rf.setValue("source-extra", modelSource);

            if (model.getEditorSourceExtraValueId().length == 0) {
                model.setEditorSourceExtraValueId(rf.getId());
                updateModel(model);
            }
        }
    }

    override
    public List!Model findModelsByQueryCriteria(ModelQueryImpl query) {
        return dataManager.findModelsByQueryCriteria(query);
    }

    override
    public long findModelCountByQueryCriteria(ModelQueryImpl query) {
        return dataManager.findModelCountByQueryCriteria(query);
    }

    override
    public byte[] findEditorSourceByModelId(string modelId) {
        ModelEntity model = findById(modelId);
        if (model is null || model.getEditorSourceValueId().length == 0) {
            return null;
        }

        ByteArrayRef rf = new ByteArrayRef(model.getEditorSourceValueId());
        return rf.getBytes();
    }

    override
    public byte[] findEditorSourceExtraByModelId(string modelId) {
        ModelEntity model = findById(modelId);
        if (model is null || model.getEditorSourceExtraValueId().length == 0) {
            return null;
        }

        ByteArrayRef rf = new ByteArrayRef(model.getEditorSourceExtraValueId());
        return rf.getBytes();
    }

    override
    public List!Model findModelsByNativeQuery(Map!(string, Object) parameterMap) {
        return dataManager.findModelsByNativeQuery(parameterMap);
    }

    override
    public long findModelCountByNativeQuery(Map!(string, Object) parameterMap) {
        return dataManager.findModelCountByNativeQuery(parameterMap);
    }

}
