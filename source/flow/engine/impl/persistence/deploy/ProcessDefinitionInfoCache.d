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
module flow.engine.impl.persistence.deploy.ProcessDefinitionInfoCache;

import hunt.collection;
import hunt.collection.HashMap;
import hunt.collection.LinkedHashMap;
import hunt.collection.Map;
import hunt.collection.ArrayList;
import flow.common.api.FlowableException;
import flow.common.context.Context;
import flow.common.interceptor.Command;
import flow.common.interceptor.CommandContext;
import flow.common.interceptor.CommandExecutor;
import flow.common.persistence.deploy.DeploymentCache;
import flow.engine.impl.persistence.entity.ProcessDefinitionInfoEntity;
import flow.engine.impl.persistence.entity.ProcessDefinitionInfoEntityManager;
import flow.engine.impl.util.CommandContextUtil;
import flow.engine.impl.persistence.deploy.ProcessDefinitionInfoCacheObject;
import hunt.Exceptions;
/**
 * Default cache: keep everything in memory, unless a limit is set.
 *
 * @author Tijs Rademakers
 */
class ProcessDefinitionInfoCache : DeploymentCache!ProcessDefinitionInfoCacheObject {

    protected Map!(string, ProcessDefinitionInfoCacheObject) cache;
    protected CommandExecutor commandExecutor;

    /** Cache with no limit */
    this(CommandExecutor commandExecutor) {
        this.commandExecutor = commandExecutor;
       // this.cache = Collections.synchronizedMap(new HashMap<>());
        this.cache = new HashMap!(string, ProcessDefinitionInfoCacheObject);
    }

    /** Cache which has a hard limit: no more elements will be cached than the limit. */
    //public ProcessDefinitionInfoCache(CommandExecutor commandExecutor, final int limit) {
    //    this.commandExecutor = commandExecutor;
    //    this.cache = Collections.synchronizedMap(new LinkedHashMap!(string, ProcessDefinitionInfoCacheObject)(limit + 1, 0.75f, true) {
    //        // +1 is needed, because the entry is inserted first, before it is removed
    //        // 0.75 is the default (see javadocs)
    //        // true will keep the 'access-order', which is needed to have a real LRU cache
    //        private static final long serialVersionUID = 1L;
    //
    //
    //        protected bool removeEldestEntry(Map.Entry!(string, ProcessDefinitionInfoCacheObject) eldest) {
    //            bool removeEldest = size() > limit;
    //            if (removeEldest) {
    //                LOGGER.trace("Cache limit is reached, {} will be evicted", eldest.getKey());
    //            }
    //            return removeEldest;
    //        }
    //
    //    });
    //}


    public ProcessDefinitionInfoCacheObject get(string processDefinitionId) {
        ProcessDefinitionInfoCacheObject infoCacheObject = null;
        Command!ProcessDefinitionInfoCacheObject cacheCommand = new class Command!ProcessDefinitionInfoCacheObject {

            public ProcessDefinitionInfoCacheObject execute(CommandContext commandContext) {
                return retrieveProcessDefinitionInfoCacheObject(processDefinitionId, commandContext);
            }
        };

        if (Context.getCommandContext() !is null) {
            infoCacheObject = retrieveProcessDefinitionInfoCacheObject(processDefinitionId, Context.getCommandContext());
        } else {
            infoCacheObject = cast(ProcessDefinitionInfoCacheObject)commandExecutor.execute(cacheCommand);
        }

        return infoCacheObject;
    }


    public bool contains(string id) {
        return cache.containsKey(id);
    }


    public void add(string id, ProcessDefinitionInfoCacheObject obj) {
        cache.put(id, obj);
    }


    public void remove(string id) {
        cache.remove(id);
    }


    public void clear() {
        cache.clear();
    }


    public Collection!ProcessDefinitionInfoCacheObject getAll() {
        return   new ArrayList!ProcessDefinitionInfoCacheObject(cache.values());
    }


    public int size() {
        return cache.size();
    }

    protected ProcessDefinitionInfoCacheObject retrieveProcessDefinitionInfoCacheObject(string processDefinitionId, CommandContext commandContext) {
        implementationMissing(false);
        return null;
        //ProcessDefinitionInfoEntityManager infoEntityManager = CommandContextUtil.getProcessDefinitionInfoEntityManager(commandContext);
        //ObjectMapper objectMapper = CommandContextUtil.getProcessEngineConfiguration(commandContext).getObjectMapper();
        //
        //ProcessDefinitionInfoCacheObject cacheObject = null;
        //if (cache.containsKey(processDefinitionId)) {
        //    cacheObject = cache.get(processDefinitionId);
        //} else {
        //    cacheObject = new ProcessDefinitionInfoCacheObject();
        //    cacheObject.setRevision(0);
        //    cacheObject.setInfoNode(objectMapper.createObjectNode());
        //}
        //
        //ProcessDefinitionInfoEntity infoEntity = infoEntityManager.findProcessDefinitionInfoByProcessDefinitionId(processDefinitionId);
        //if (infoEntity !is null && infoEntity.getRevision() != cacheObject.getRevision()) {
        //    cacheObject.setRevision(infoEntity.getRevision());
        //    if (infoEntity.getInfoJsonId() !is null) {
        //        byte[] infoBytes = infoEntityManager.findInfoJsonById(infoEntity.getInfoJsonId());
        //        try {
        //            ObjectNode infoNode = (ObjectNode) objectMapper.readTree(infoBytes);
        //            cacheObject.setInfoNode(infoNode);
        //        } catch (Exception e) {
        //            throw new FlowableException("Error reading json info node for process definition " + processDefinitionId, e);
        //        }
        //    }
        //} else if (infoEntity is null) {
        //    cacheObject.setRevision(0);
        //    cacheObject.setInfoNode(objectMapper.createObjectNode());
        //}
        //
        //return cacheObject;
    }

}
