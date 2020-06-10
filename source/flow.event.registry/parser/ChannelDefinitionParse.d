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
module flow.event.registry.parser.ChannelDefinitionParse;

//import java.io.InputStream;
//import java.io.InputStreamReader;
//import java.io.UnsupportedEncodingException;
//import java.net.MalformedURLException;
//import java.net.URL;
//import hunt.collection.ArrayList;
//import hunt.time.LocalDateTime;
//import hunt.collection.List;
//
//import org.apache.commons.io.IOUtils;
//import flow.common.api.FlowableException;
//import flow.common.util.io.InputStreamSource;
//import flow.common.util.io.StreamSource;
//import flow.common.util.io.StringStreamSource;
//import flow.common.util.io.UrlStreamSource;
//import flow.event.registry.EventRegistryEngineConfiguration;
//import flow.event.registry.io.ResourceStreamSource;
//import flow.event.registry.persistence.entity.ChannelDefinitionEntity;
//import flow.event.registry.persistence.entity.EventDeploymentEntity;
//import flow.event.registry.json.converter.ChannelJsonConverter;
//import flow.event.registry.model.ChannelModel;
//import org.slf4j.Logger;
//import org.slf4j.LoggerFactory;
//
///**
// * Specific parsing of one channel json file.
// *
// * @author Tijs Rademakers
// * @author Joram Barrez
// */
//class ChannelDefinitionParse {
//
//    protected static final Logger LOGGER = LoggerFactory.getLogger(ChannelDefinitionParse.class);
//
//    protected String name;
//
//    protected StreamSource streamSource;
//
//    protected String sourceSystemId;
//
//    protected ChannelModel channelModel;
//
//    /** The deployment to which the parsed decision tables will be added. */
//    protected EventDeploymentEntity deployment;
//
//    /** The end result of the parsing: a list of channel definitions. */
//    protected List<ChannelDefinitionEntity> channelDefinitions = new ArrayList<>();
//
//    public ChannelDefinitionParse deployment(EventDeploymentEntity deployment) {
//        this.deployment = deployment;
//        return this;
//    }
//
//    public ChannelDefinitionParse execute(EventRegistryEngineConfiguration eventEngineConfig) {
//        String encoding = eventEngineConfig.getXmlEncoding();
//        ChannelJsonConverter converter = new ChannelJsonConverter();
//
//        try (InputStreamReader in = newInputStreamReaderForSource(encoding)) {
//            String channelJson = IOUtils.toString(in);
//            channelModel = converter.convertToChannelModel(channelJson);
//
//            if (channelModel !is null && channelModel.getKey() !is null) {
//                ChannelDefinitionEntity channelDefinitionEntity = eventEngineConfig.getChannelDefinitionEntityManager().create();
//                channelDefinitionEntity.setCreateTime(new Date());
//                channelDefinitionEntity.setKey(channelModel.getKey());
//                channelDefinitionEntity.setCategory(channelModel.getCategory());
//                channelDefinitionEntity.setName(channelModel.getName());
//                channelDefinitionEntity.setDescription(channelModel.getDescription());
//                channelDefinitionEntity.setResourceName(name);
//                channelDefinitionEntity.setDeploymentId(deployment.getId());
//                channelDefinitions.add(channelDefinitionEntity);
//            }
//        } catch (Exception e) {
//            throw new FlowableException("Error parsing channel definition JSON", e);
//        }
//        return this;
//    }
//
//    private InputStreamReader newInputStreamReaderForSource(String encoding) throws UnsupportedEncodingException {
//        if (encoding !is null) {
//            return new InputStreamReader(streamSource.getInputStream(), encoding);
//        } else {
//            return new InputStreamReader(streamSource.getInputStream());
//        }
//    }
//
//    public ChannelDefinitionParse name(String name) {
//        this.name = name;
//        return this;
//    }
//
//    public ChannelDefinitionParse sourceInputStream(InputStream inputStream) {
//        if (name is null) {
//            name("inputStream");
//        }
//        setStreamSource(new InputStreamSource(inputStream));
//        return this;
//    }
//
//    public String getSourceSystemId() {
//        return sourceSystemId;
//    }
//
//    public ChannelDefinitionParse setSourceSystemId(String sourceSystemId) {
//        this.sourceSystemId = sourceSystemId;
//        return this;
//    }
//
//    public ChannelDefinitionParse sourceUrl(URL url) {
//        if (name is null) {
//            name(url.toString());
//        }
//        setStreamSource(new UrlStreamSource(url));
//        return this;
//    }
//
//    public ChannelDefinitionParse sourceUrl(String url) {
//        try {
//            return sourceUrl(new URL(url));
//        } catch (MalformedURLException e) {
//            throw new FlowableException("malformed url: " + url, e);
//        }
//    }
//
//    public ChannelDefinitionParse sourceResource(String resource) {
//        if (name is null) {
//            name(resource);
//        }
//        setStreamSource(new ResourceStreamSource(resource));
//        return this;
//    }
//
//    public ChannelDefinitionParse sourceString(String string) {
//        if (name is null) {
//            name("string");
//        }
//        setStreamSource(new StringStreamSource(string));
//        return this;
//    }
//
//    protected void setStreamSource(StreamSource streamSource) {
//        if (this.streamSource !is null) {
//            throw new FlowableException("invalid: multiple sources " + this.streamSource + " and " + streamSource);
//        }
//        this.streamSource = streamSource;
//    }
//
//    /*
//     * ------------------- GETTERS AND SETTERS -------------------
//     */
//
//    public List<ChannelDefinitionEntity> getChannelDefinitions() {
//        return channelDefinitions;
//    }
//
//    public EventDeploymentEntity getDeployment() {
//        return deployment;
//    }
//
//    public void setDeployment(EventDeploymentEntity deployment) {
//        this.deployment = deployment;
//    }
//
//    public ChannelModel getChannelModel() {
//        return channelModel;
//    }
//
//    public void setChannelModel(ChannelModel channelModel) {
//        this.channelModel = channelModel;
//    }
//}
