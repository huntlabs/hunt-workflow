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




import flow.engine.impl.persistence.entity.DeploymentEntityImpl;
import hunt.stream.Common;
//import java.io.Serializable;
//import java.nio.charset.StandardCharsets;
import hunt.time.LocalDateTime;
import hunt.collection.HashMap;
import hunt.collection.Map;
//import java.util.zip.ZipEntry;
//import java.util.zip.ZipInputStream;

import flow.bpmn.converter.converter.BpmnXMLConverter;
import flow.bpmn.model.BpmnModel;
import flow.common.api.FlowableException;
import flow.common.api.FlowableIllegalArgumentException;
//import flow.common.util.IoUtil;
//import flow.common.util.ReflectUtil;
import flow.engine.impl.RepositoryServiceImpl;
import flow.engine.impl.persistence.entity.DeploymentEntity;
import flow.engine.impl.persistence.entity.ResourceEntity;
import flow.engine.impl.persistence.entity.ResourceEntityManager;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.repository.Deployment;
import flow.engine.repository.DeploymentBuilder;
import flow.engine.impl.persistence.entity.ResourceEntityImpl;
import hunt.Exceptions;
import std.file;
/**
 * @author Tom Baeyens
 * @author Joram Barrez
 */
class DeploymentBuilderImpl : DeploymentBuilder {

    protected  string DEFAULT_ENCODING = "UTF-8";

    protected  RepositoryServiceImpl repositoryService;
    protected  ResourceEntityManager resourceEntityManager;

    protected DeploymentEntity deployment;
    protected bool _isBpmn20XsdValidationEnabled = true;
    protected bool _isProcessValidationEnabled = true;
    protected bool _isDuplicateFilterEnabled;
    protected Date processDefinitionsActivationDate;
    protected Map!(string, Object) deploymentProperties ;//= new HashMap<>();

    this(RepositoryServiceImpl repositoryService) {
        this.repositoryService = repositoryService;
        this.deployment = new DeploymentEntityImpl(); //CommandContextUtil.getProcessEngineConfiguration().getDeploymentEntityManager().create();
        this.resourceEntityManager = CommandContextUtil.getProcessEngineConfiguration().getResourceEntityManager();
        this.deploymentProperties = new HashMap!(string, Object);
    }


    public DeploymentBuilder addInputStream(string resourceName, string inputStream) {
        if (inputStream is null) {
            throw new FlowableIllegalArgumentException("inputStream for resource '" ~ resourceName ~ "' is null");
        }
        //implementationMissing(false);
        //byte[] bytes = IoUtil.readInputStream(inputStream, resourceName);
        ResourceEntity resource = new ResourceEntityImpl(); //= resourceEntityManager.create();
        resource.setName(resourceName);
        resource.setBytes(cast(byte[])inputStream);
        deployment.addResource(resource);
        return this;
    }


    public DeploymentBuilder addClasspathResource(string resource) {
        //implementationMissing(false);
        //InputStream inputStream = ReflectUtil.getResourceAsStream(resource);
        //if (inputStream is null) {
        //    throw new FlowableIllegalArgumentException("resource '" + resource + "' not found");
        //}
       // return addInputStream(resource, inputStream);
         string str = readText(resource);
        //Document doc = Document.load(resource);
        return addInputStream(resource,str);
       // return this;
    }


    public DeploymentBuilder addString(string resourceName, string text) {
        implementationMissing(false);
        //if (text is null) {
        //    throw new FlowableIllegalArgumentException("text is null");
        //}
        //ResourceEntity resource = resourceEntityManager.create();
        //resource.setName(resourceName);
        //try {
        //    resource.setBytes(text.getBytes(DEFAULT_ENCODING));
        //} catch (UnsupportedEncodingException e) {
        //    throw new FlowableException("Unable to get process bytes.", e);
        //}
        //deployment.addResource(resource);
        return this;
    }


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


    //public DeploymentBuilder addZipInputStream(ZipInputStream zipInputStream) {
    //    try {
    //        ZipEntry entry = zipInputStream.getNextEntry();
    //        while (entry !is null) {
    //            if (!entry.isDirectory()) {
    //                string entryName = entry.getName();
    //                byte[] bytes = IoUtil.readInputStream(zipInputStream, entryName);
    //                ResourceEntity resource = resourceEntityManager.create();
    //                resource.setName(entryName);
    //                resource.setBytes(bytes);
    //                deployment.addResource(resource);
    //            }
    //            entry = zipInputStream.getNextEntry();
    //        }
    //    } catch (Exception e) {
    //        throw new FlowableException("problem reading zip input stream", e);
    //    }
    //    return this;
    //}


    public DeploymentBuilder addBpmnModel(string resourceName, BpmnModel bpmnModel) {
        implementationMissing(false);
        //BpmnXMLConverter bpmnXMLConverter = new BpmnXMLConverter();
        //string bpmn20Xml = new string(bpmnXMLConverter.convertToXML(bpmnModel), StandardCharsets.UTF_8);
        //addString(resourceName, bpmn20Xml);
        return this;
    }


    public DeploymentBuilder name(string name) {
        deployment.setName(name);
        return this;
    }


    public DeploymentBuilder category(string category) {
        deployment.setCategory(category);
        return this;
    }


    public DeploymentBuilder key(string key) {
        deployment.setKey(key);
        return this;
    }


    public DeploymentBuilder parentDeploymentId(string parentDeploymentId) {
        deployment.setParentDeploymentId(parentDeploymentId);
        return this;
    }


    public DeploymentBuilder disableBpmnValidation() {
        this._isProcessValidationEnabled = false;
        return this;
    }


    public DeploymentBuilder disableSchemaValidation() {
        this._isBpmn20XsdValidationEnabled = false;
        return this;
    }


    public DeploymentBuilder tenantId(string tenantId) {
        deployment.setTenantId(tenantId);
        return this;
    }


    public DeploymentBuilder enableDuplicateFiltering() {
        this._isDuplicateFilterEnabled = true;
        return this;
    }


    public DeploymentBuilder activateProcessDefinitionsOn(Date date) {
        this.processDefinitionsActivationDate = date;
        return this;
    }


    public DeploymentBuilder deploymentProperty(string propertyKey, Object propertyValue) {
        deploymentProperties.put(propertyKey, propertyValue);
        return this;
    }


    public Deployment deploy() {
        return repositoryService.deploy(this);
    }

    // getters and setters
    // //////////////////////////////////////////////////////

    public DeploymentEntity getDeployment() {
        return deployment;
    }

    public bool isProcessValidationEnabled() {
        return _isProcessValidationEnabled;
    }

    public bool isBpmn20XsdValidationEnabled() {
        return _isBpmn20XsdValidationEnabled;
    }

    public bool isDuplicateFilterEnabled() {
        return _isDuplicateFilterEnabled;
    }

    public Date getProcessDefinitionsActivationDate() {
        return processDefinitionsActivationDate;
    }

    public Map!(string, Object) getDeploymentProperties() {
        return deploymentProperties;
    }

}
