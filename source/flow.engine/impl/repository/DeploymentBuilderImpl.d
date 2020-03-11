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

//          Copyright linse 2020.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)}

module flow.engine.impl.repository.DeploymentBuilderImpl;





import hunt.io.Common;
//import java.io.Serializable;
//import java.nio.charset.StandardCharsets;
import hunt.time.LocalDateTime;
import hunt.collection.HashMap;
import hunt.collection.Map;
//import java.util.zip.ZipEntry;
//import java.util.zip.ZipInputStream;

import org.flowable.bpmn.converter.BpmnXMLConverter;
import flow.bpmn.model.BpmnModel;
import flow.common.api.FlowableException;
import flow.common.api.FlowableIllegalArgumentException;
import flow.common.util.IoUtil;
import flow.common.util.ReflectUtil;
import flow.engine.impl.RepositoryServiceImpl;
import flow.engine.impl.persistence.entity.DeploymentEntity;
import flow.engine.impl.persistence.entity.ResourceEntity;
import flow.engine.impl.persistence.entity.ResourceEntityManager;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.repository.Deployment;
import flow.engine.repository.DeploymentBuilder;

/**
 * @author Tom Baeyens
 * @author Joram Barrez
 */
class DeploymentBuilderImpl : DeploymentBuilder {

    private static  long serialVersionUID = 1L;
    protected  final string DEFAULT_ENCODING = "UTF-8";

    protected  RepositoryServiceImpl repositoryService;
    protected  ResourceEntityManager resourceEntityManager;

    protected DeploymentEntity deployment;
    protected bool isBpmn20XsdValidationEnabled = true;
    protected bool isProcessValidationEnabled = true;
    protected bool isDuplicateFilterEnabled;
    protected Date processDefinitionsActivationDate;
    protected Map!(string, Object) deploymentProperties ;//= new HashMap<>();

    this(RepositoryServiceImpl repositoryService) {
        this.repositoryService = repositoryService;
        this.deployment = CommandContextUtil.getProcessEngineConfiguration().getDeploymentEntityManager().create();
        this.resourceEntityManager = CommandContextUtil.getProcessEngineConfiguration().getResourceEntityManager();
        this.deploymentProperties = new HashMap!(string, Object);
    }

    @Override
    public DeploymentBuilder addInputStream(string resourceName, InputStream inputStream) {
        if (inputStream is null) {
            throw new FlowableIllegalArgumentException("inputStream for resource '" + resourceName + "' is null");
        }
        byte[] bytes = IoUtil.readInputStream(inputStream, resourceName);
        ResourceEntity resource = resourceEntityManager.create();
        resource.setName(resourceName);
        resource.setBytes(bytes);
        deployment.addResource(resource);
        return this;
    }

    @Override
    public DeploymentBuilder addClasspathResource(string resource) {
        InputStream inputStream = ReflectUtil.getResourceAsStream(resource);
        if (inputStream is null) {
            throw new FlowableIllegalArgumentException("resource '" + resource + "' not found");
        }
        return addInputStream(resource, inputStream);
    }

    @Override
    public DeploymentBuilder addString(string resourceName, string text) {
        if (text is null) {
            throw new FlowableIllegalArgumentException("text is null");
        }
        ResourceEntity resource = resourceEntityManager.create();
        resource.setName(resourceName);
        try {
            resource.setBytes(text.getBytes(DEFAULT_ENCODING));
        } catch (UnsupportedEncodingException e) {
            throw new FlowableException("Unable to get process bytes.", e);
        }
        deployment.addResource(resource);
        return this;
    }

    @Override
    public DeploymentBuilder addBytes(string resourceName, byte[] bytes) {
        if (bytes is null) {
            throw new FlowableIllegalArgumentException("bytes is null");
        }
        ResourceEntity resource = resourceEntityManager.create();
        resource.setName(resourceName);
        resource.setBytes(bytes);

        deployment.addResource(resource);
        return this;
    }

    @Override
    public DeploymentBuilder addZipInputStream(ZipInputStream zipInputStream) {
        try {
            ZipEntry entry = zipInputStream.getNextEntry();
            while (entry !is null) {
                if (!entry.isDirectory()) {
                    string entryName = entry.getName();
                    byte[] bytes = IoUtil.readInputStream(zipInputStream, entryName);
                    ResourceEntity resource = resourceEntityManager.create();
                    resource.setName(entryName);
                    resource.setBytes(bytes);
                    deployment.addResource(resource);
                }
                entry = zipInputStream.getNextEntry();
            }
        } catch (Exception e) {
            throw new FlowableException("problem reading zip input stream", e);
        }
        return this;
    }

    @Override
    public DeploymentBuilder addBpmnModel(string resourceName, BpmnModel bpmnModel) {
        BpmnXMLConverter bpmnXMLConverter = new BpmnXMLConverter();
        string bpmn20Xml = new string(bpmnXMLConverter.convertToXML(bpmnModel), StandardCharsets.UTF_8);
        addString(resourceName, bpmn20Xml);
        return this;
    }

    @Override
    public DeploymentBuilder name(string name) {
        deployment.setName(name);
        return this;
    }

    @Override
    public DeploymentBuilder category(string category) {
        deployment.setCategory(category);
        return this;
    }

    @Override
    public DeploymentBuilder key(string key) {
        deployment.setKey(key);
        return this;
    }

    @Override
    public DeploymentBuilder parentDeploymentId(string parentDeploymentId) {
        deployment.setParentDeploymentId(parentDeploymentId);
        return this;
    }

    @Override
    public DeploymentBuilder disableBpmnValidation() {
        this.isProcessValidationEnabled = false;
        return this;
    }

    @Override
    public DeploymentBuilder disableSchemaValidation() {
        this.isBpmn20XsdValidationEnabled = false;
        return this;
    }

    @Override
    public DeploymentBuilder tenantId(string tenantId) {
        deployment.setTenantId(tenantId);
        return this;
    }

    @Override
    public DeploymentBuilder enableDuplicateFiltering() {
        this.isDuplicateFilterEnabled = true;
        return this;
    }

    @Override
    public DeploymentBuilder activateProcessDefinitionsOn(Date date) {
        this.processDefinitionsActivationDate = date;
        return this;
    }

    @Override
    public DeploymentBuilder deploymentProperty(string propertyKey, Object propertyValue) {
        deploymentProperties.put(propertyKey, propertyValue);
        return this;
    }

    @Override
    public Deployment deploy() {
        return repositoryService.deploy(this);
    }

    // getters and setters
    // //////////////////////////////////////////////////////

    public DeploymentEntity getDeployment() {
        return deployment;
    }

    public bool isProcessValidationEnabled() {
        return isProcessValidationEnabled;
    }

    public bool isBpmn20XsdValidationEnabled() {
        return isBpmn20XsdValidationEnabled;
    }

    public bool isDuplicateFilterEnabled() {
        return isDuplicateFilterEnabled;
    }

    public Date getProcessDefinitionsActivationDate() {
        return processDefinitionsActivationDate;
    }

    public Map!(string, Object) getDeploymentProperties() {
        return deploymentProperties;
    }

}
