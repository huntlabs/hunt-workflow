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
module flow.variable.service.VariableServiceConfiguration;

import flow.common.AbstractServiceConfiguration;
import flow.variable.service.api.types.VariableTypes;
import flow.variable.service.history.InternalHistoryVariableManager;
import flow.variable.service.impl.HistoricVariableServiceImpl;
import flow.variable.service.impl.VariableServiceImpl;
import flow.variable.service.impl.persistence.entity.HistoricVariableInstanceEntityManager;
import flow.variable.service.impl.persistence.entity.HistoricVariableInstanceEntityManagerImpl;
import flow.variable.service.impl.persistence.entity.VariableByteArrayEntityManager;
import flow.variable.service.impl.persistence.entity.VariableByteArrayEntityManagerImpl;
import flow.variable.service.impl.persistence.entity.VariableInstanceEntityManager;
import flow.variable.service.impl.persistence.entity.VariableInstanceEntityManagerImpl;
import flow.variable.service.impl.persistence.entity.data.HistoricVariableInstanceDataManager;
import flow.variable.service.impl.persistence.entity.data.VariableByteArrayDataManager;
import flow.variable.service.impl.persistence.entity.data.VariableInstanceDataManager;
import flow.variable.service.impl.persistence.entity.data.impl.MybatisHistoricVariableInstanceDataManager;
import flow.variable.service.impl.persistence.entity.data.impl.MybatisVariableByteArrayDataManager;
import flow.variable.service.impl.persistence.entity.data.impl.MybatisVariableInstanceDataManager;
import flow.variable.service.VariableService;
import flow.variable.service.HistoricVariableService;
/**
 * @author Tijs Rademakers
 */
class VariableServiceConfiguration : AbstractServiceConfiguration {

    public static  int DEFAULT_GENERIC_MAX_LENGTH_STRING = 4000;
    public static  int DEFAULT_ORACLE_MAX_LENGTH_STRING = 2000;

    // SERVICES
    // /////////////////////////////////////////////////////////////////

    protected VariableService variableService  ;//= new VariableServiceImpl(this);
    protected HistoricVariableService historicVariableService ;// = new HistoricVariableServiceImpl(this);

    // DATA MANAGERS ///////////////////////////////////////////////////

    protected VariableInstanceDataManager variableInstanceDataManager;
    protected VariableByteArrayDataManager byteArrayDataManager;
    protected HistoricVariableInstanceDataManager historicVariableInstanceDataManager;

    // ENTITY MANAGERS /////////////////////////////////////////////////

    protected VariableInstanceEntityManager variableInstanceEntityManager;
    protected VariableByteArrayEntityManager byteArrayEntityManager;
    protected HistoricVariableInstanceEntityManager historicVariableInstanceEntityManager;

    protected VariableTypes variableTypes;

    protected InternalHistoryVariableManager internalHistoryVariableManager;

    protected int maxLengthString;

    protected bool loggingSessionEnabled;

    /**
     * This flag determines whether variables of the type 'serializable' will be tracked. This means that, when true, in a JavaDelegate you can write
     *
     * MySerializableVariable myVariable = (MySerializableVariable) execution.getVariable("myVariable"); myVariable.setNumber(123);
     *
     * And the changes to the java object will be reflected in the database. Otherwise, a manual call to setVariable will be needed.
     *
     * By default true for backwards compatibility.
     */
    protected bool serializableVariableTypeTrackDeserializedObjects = true;

    this(string engineName) {
        super(engineName);
        variableService = new VariableServiceImpl(this);
        historicVariableService = new HistoricVariableServiceImpl(this);
    }

    // init
    // /////////////////////////////////////////////////////////////////////

    public void init() {
        initDataManagers();
        initEntityManagers();
    }

    // Data managers
    ///////////////////////////////////////////////////////////

    public void initDataManagers() {
        if (variableInstanceDataManager is null) {
            variableInstanceDataManager = new MybatisVariableInstanceDataManager();
        }
        if (byteArrayDataManager is null) {
            byteArrayDataManager = new MybatisVariableByteArrayDataManager();
        }
        if (historicVariableInstanceDataManager is null) {
            historicVariableInstanceDataManager = new MybatisHistoricVariableInstanceDataManager();
        }
    }

    public void initEntityManagers() {
        if (variableInstanceEntityManager is null) {
            variableInstanceEntityManager = new VariableInstanceEntityManagerImpl(this, variableInstanceDataManager);
        }
        if (byteArrayEntityManager is null) {
            byteArrayEntityManager = new VariableByteArrayEntityManagerImpl(this, byteArrayDataManager);
        }
        if (historicVariableInstanceEntityManager is null) {
            historicVariableInstanceEntityManager = new HistoricVariableInstanceEntityManagerImpl(this, historicVariableInstanceDataManager);
        }
    }

    // getters and setters
    // //////////////////////////////////////////////////////

    public VariableServiceConfiguration getVariableServiceConfiguration() {
        return this;
    }

    public VariableService getVariableService() {
        return variableService;
    }

    public VariableServiceConfiguration setVariableService(VariableService variableService) {
        this.variableService = variableService;
        return this;
    }

    public HistoricVariableService getHistoricVariableService() {
        return historicVariableService;
    }

    public VariableServiceConfiguration setHistoricVariableService(HistoricVariableService historicVariableService) {
        this.historicVariableService = historicVariableService;
        return this;
    }

    public VariableInstanceDataManager getVariableInstanceDataManager() {
        return variableInstanceDataManager;
    }

    public VariableServiceConfiguration setVariableInstanceDataManager(VariableInstanceDataManager variableInstanceDataManager) {
        this.variableInstanceDataManager = variableInstanceDataManager;
        return this;
    }

    public VariableByteArrayDataManager getByteArrayDataManager() {
        return byteArrayDataManager;
    }

    public VariableServiceConfiguration setByteArrayDataManager(VariableByteArrayDataManager byteArrayDataManager) {
        this.byteArrayDataManager = byteArrayDataManager;
        return this;
    }

    public HistoricVariableInstanceDataManager getHistoricVariableInstanceDataManager() {
        return historicVariableInstanceDataManager;
    }

    public VariableServiceConfiguration setHistoricVariableInstanceDataManager(HistoricVariableInstanceDataManager historicVariableInstanceDataManager) {
        this.historicVariableInstanceDataManager = historicVariableInstanceDataManager;
        return this;
    }

    public VariableInstanceEntityManager getVariableInstanceEntityManager() {
        return variableInstanceEntityManager;
    }

    public VariableServiceConfiguration setVariableInstanceEntityManager(VariableInstanceEntityManager variableInstanceEntityManager) {
        this.variableInstanceEntityManager = variableInstanceEntityManager;
        return this;
    }

    public VariableByteArrayEntityManager getByteArrayEntityManager() {
        return byteArrayEntityManager;
    }

    public VariableServiceConfiguration setByteArrayEntityManager(VariableByteArrayEntityManager byteArrayEntityManager) {
        this.byteArrayEntityManager = byteArrayEntityManager;
        return this;
    }

    public HistoricVariableInstanceEntityManager getHistoricVariableInstanceEntityManager() {
        return historicVariableInstanceEntityManager;
    }

    public VariableServiceConfiguration setHistoricVariableInstanceEntityManager(HistoricVariableInstanceEntityManager historicVariableInstanceEntityManager) {
        this.historicVariableInstanceEntityManager = historicVariableInstanceEntityManager;
        return this;
    }

    public VariableTypes getVariableTypes() {
        return variableTypes;
    }

    public VariableServiceConfiguration setVariableTypes(VariableTypes variableTypes) {
        this.variableTypes = variableTypes;
        return this;
    }

    public InternalHistoryVariableManager getInternalHistoryVariableManager() {
        return internalHistoryVariableManager;
    }

    public VariableServiceConfiguration setInternalHistoryVariableManager(InternalHistoryVariableManager internalHistoryVariableManager) {
        this.internalHistoryVariableManager = internalHistoryVariableManager;
        return this;
    }

    public int getMaxLengthString() {
        return maxLengthString;
    }

    public VariableServiceConfiguration setMaxLengthString(int maxLengthString) {
        this.maxLengthString = maxLengthString;
        return this;
    }

    public bool isLoggingSessionEnabled() {
        return loggingSessionEnabled;
    }

    public VariableServiceConfiguration setLoggingSessionEnabled(bool loggingSessionEnabled) {
        this.loggingSessionEnabled = loggingSessionEnabled;
        return this;
    }

    public bool isSerializableVariableTypeTrackDeserializedObjects() {
        return serializableVariableTypeTrackDeserializedObjects;
    }

    public void setSerializableVariableTypeTrackDeserializedObjects(bool serializableVariableTypeTrackDeserializedObjects) {
        this.serializableVariableTypeTrackDeserializedObjects = serializableVariableTypeTrackDeserializedObjects;
    }
}
