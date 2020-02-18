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



import java.util.List;
import java.util.Map;

import flow.engine.impl.ModelQueryImpl;
import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
import flow.engine.impl.persistence.entity.data.ModelDataManager;
import flow.engine.repository.Model;

/**
 * @author Tijs Rademakers
 * @author Joram Barrez
 */
class ModelEntityManagerImpl
    extends AbstractProcessEngineEntityManager<ModelEntity, ModelDataManager>
    implements ModelEntityManager {

    public ModelEntityManagerImpl(ProcessEngineConfigurationImpl processEngineConfiguration, ModelDataManager modelDataManager) {
        super(processEngineConfiguration, modelDataManager);
    }

    @Override
    public ModelEntity findById(string entityId) {
        return dataManager.findById(entityId);
    }

    @Override
    public void insert(ModelEntity model) {
        model.setCreateTime(getClock().getCurrentTime());
        model.setLastUpdateTime(getClock().getCurrentTime());

        super.insert(model);
    }

    @Override
    public void updateModel(ModelEntity updatedModel) {
        updatedModel.setLastUpdateTime(getClock().getCurrentTime());
        update(updatedModel);
    }

    @Override
    public void delete(string modelId) {
        ModelEntity modelEntity = findById(modelId);
        super.delete(modelEntity);
        deleteEditorSource(modelEntity);
        deleteEditorSourceExtra(modelEntity);
    }

    @Override
    public void insertEditorSourceForModel(string modelId, byte[] modelSource) {
        ModelEntity model = findById(modelId);
        if (model !is null) {
            ByteArrayRef ref = new ByteArrayRef(model.getEditorSourceValueId());
            ref.setValue("source", modelSource);

            if (model.getEditorSourceValueId() is null) {
                model.setEditorSourceValueId(ref.getId());
                updateModel(model);
            }
        }
    }

    @Override
    public void deleteEditorSource(ModelEntity model) {
        if (model.getEditorSourceValueId() !is null) {
            ByteArrayRef ref = new ByteArrayRef(model.getEditorSourceValueId());
            ref.delete();
        }
    }

    @Override
    public void deleteEditorSourceExtra(ModelEntity model) {
        if (model.getEditorSourceExtraValueId() !is null) {
            ByteArrayRef ref = new ByteArrayRef(model.getEditorSourceExtraValueId());
            ref.delete();
        }
    }

    @Override
    public void insertEditorSourceExtraForModel(string modelId, byte[] modelSource) {
        ModelEntity model = findById(modelId);
        if (model !is null) {
            ByteArrayRef ref = new ByteArrayRef(model.getEditorSourceExtraValueId());
            ref.setValue("source-extra", modelSource);

            if (model.getEditorSourceExtraValueId() is null) {
                model.setEditorSourceExtraValueId(ref.getId());
                updateModel(model);
            }
        }
    }

    @Override
    public List<Model> findModelsByQueryCriteria(ModelQueryImpl query) {
        return dataManager.findModelsByQueryCriteria(query);
    }

    @Override
    public long findModelCountByQueryCriteria(ModelQueryImpl query) {
        return dataManager.findModelCountByQueryCriteria(query);
    }

    @Override
    public byte[] findEditorSourceByModelId(string modelId) {
        ModelEntity model = findById(modelId);
        if (model is null || model.getEditorSourceValueId() is null) {
            return null;
        }

        ByteArrayRef ref = new ByteArrayRef(model.getEditorSourceValueId());
        return ref.getBytes();
    }

    @Override
    public byte[] findEditorSourceExtraByModelId(string modelId) {
        ModelEntity model = findById(modelId);
        if (model is null || model.getEditorSourceExtraValueId() is null) {
            return null;
        }

        ByteArrayRef ref = new ByteArrayRef(model.getEditorSourceExtraValueId());
        return ref.getBytes();
    }

    @Override
    public List<Model> findModelsByNativeQuery(Map<string, Object> parameterMap) {
        return dataManager.findModelsByNativeQuery(parameterMap);
    }

    @Override
    public long findModelCountByNativeQuery(Map<string, Object> parameterMap) {
        return dataManager.findModelCountByNativeQuery(parameterMap);
    }

}
