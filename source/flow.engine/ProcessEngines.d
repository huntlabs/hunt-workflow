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
 
module flow.engine.ProcessEngines;
 
 
 


//import java.io.IOException;
//import java.io.InputStream;
//import java.lang.reflect.Method;
//import java.net.MalformedURLException;
//import java.net.URL;
//import java.util.ArrayList;
//import java.util.Enumeration;
//import java.util.HashMap;
//import java.util.HashSet;
//import java.util.List;
//import java.util.Map;
//import java.util.Set;

import hunt.collection.Map;
import hunt.collection.HashMap;
import hunt.collection.ArrayList;
import flow.common.api.FlowableException;
import flow.common.api.FlowableIllegalArgumentException;
import flow.common.EngineInfo;
import std.concurrency : initOnce;
import flow.engine.ProcessEngine;

/**
 * Helper for initializing and closing process engines in server environments. <br>
 * All created {@link ProcessEngine}s will be registered with this class. <br>
 * The flowable-webapp-init webapp will call the {@link #init()} method when the webapp is deployed and it will call the {@link #destroy()} method when the webapp is destroyed, using a
 * context-listener ( <code>org.flowable.impl.servlet.listener.ProcessEnginesServletContextListener</code> ). That way, all applications can just use the {@link #getProcessEngines()} to obtain
 * pre-initialized and cached process engines. <br>
 * <br>
 * Please note that there is <b>no lazy initialization</b> of process engines, so make sure the context-listener is configured or {@link ProcessEngine}s are already created so they were registered on
 * this class.<br>
 * <br>
 * The {@link #init()} method will try to build one {@link ProcessEngine} for each flowable.cfg.xml file found on the classpath. If you have more then one, make sure you specify different
 * process.engine.name values.
 * 
 * @author Tom Baeyens
 * @author Joram Barrez
 */
abstract class ProcessEngines {

    public static string NAME_DEFAULT = "default";

    protected static bool isInitialized;
    protected static Map<string, ProcessEngine> processEngines = new HashMap<>();
    protected static Map<string, EngineInfo> processEngineInfosByName = new HashMap<>();
    protected static Map<string, EngineInfo> processEngineInfosByResourceUrl = new HashMap<>();
    protected static List<EngineInfo> processEngineInfos = new ArrayList<>();


     static Map!(string, ProcessEngine) processEngines() {
         __gshared Map!(string, ProcessEngine) inst;
         return initOnce!inst(new HashMap!(string, ProcessEngine));
     }

    /**
     * Initializes all process engines that can be found on the classpath for resources <code>flowable.cfg.xml</code> (plain Flowable style configuration) and for resources
     * <code>flowable-context.xml</code> (Spring style configuration).
     */
    public static synchronized void init() {
        if (!isInitialized()) {
            if (processEngines is null) {
                // Create new map to store process-engines if current map is null
                processEngines = new HashMap<>();
            }
            ClassLoader classLoader = ReflectUtil.getClassLoader();
            Enumeration<URL> resources = null;
            try {
                resources = classLoader.getResources("flowable.cfg.xml");
            } catch (IOException e) {
                throw new FlowableIllegalArgumentException("problem retrieving flowable.cfg.xml resources on the classpath: " + System.getProperty("java.class.path"), e);
            }

            // Remove duplicated configuration URL's using set. Some
            // classloaders may return identical URL's twice, causing duplicate
            // startups
            Set<URL> configUrls = new HashSet<>();
            while (resources.hasMoreElements()) {
                configUrls.add(resources.nextElement());
            }
            for (URL resource : configUrls) {
                LOGGER.info("Initializing process engine using configuration '{}'", resource);
                initProcessEngineFromResource(resource);
            }

            try {
                resources = classLoader.getResources("flowable-context.xml");
            } catch (IOException e) {
                throw new FlowableIllegalArgumentException("problem retrieving flowable-context.xml resources on the classpath: " + System.getProperty("java.class.path"), e);
            }
            while (resources.hasMoreElements()) {
                URL resource = resources.nextElement();
                LOGGER.info("Initializing process engine using Spring configuration '{}'", resource);
                initProcessEngineFromSpringResource(resource);
            }

            setInitialized(true);
        } else {
            LOGGER.info("Process engines already initialized");
        }
    }

    protected static void initProcessEngineFromSpringResource(URL resource) {
        try {
            Class<?> springConfigurationHelperClass = ReflectUtil.loadClass("org.flowable.spring.SpringConfigurationHelper");
            Method method = springConfigurationHelperClass.getDeclaredMethod("buildProcessEngine", new Class<?>[] { URL.class });
            ProcessEngine processEngine = (ProcessEngine) method.invoke(null, new Object[] { resource });

            string processEngineName = processEngine.getName();
            EngineInfo processEngineInfo = new EngineInfo(processEngineName, resource.toString(), null);
            processEngineInfosByName.put(processEngineName, processEngineInfo);
            processEngineInfosByResourceUrl.put(resource.toString(), processEngineInfo);

        } catch (Exception e) {
            throw new FlowableException("couldn't initialize process engine from spring configuration resource " + resource + ": " + e.getMessage(), e);
        }
    }

    /**
     * Registers the given process engine. No {@link EngineInfo} will be available for this process engine. An engine that is registered will be closed when the {@link ProcessEngines#destroy()} is
     * called.
     */
    public static void registerProcessEngine(ProcessEngine processEngine) {
        processEngines.put(processEngine.getName(), processEngine);
    }

    /**
     * Unregisters the given process engine.
     */
    public static void unregister(ProcessEngine processEngine) {
        processEngines.remove(processEngine.getName());
    }

    private static EngineInfo initProcessEngineFromResource(URL resourceUrl) {
        EngineInfo processEngineInfo = processEngineInfosByResourceUrl.get(resourceUrl.toString());
        // if there is an existing process engine info
        if (processEngineInfo !is null) {
            // remove that process engine from the member fields
            processEngineInfos.remove(processEngineInfo);
            if (processEngineInfo.getException() is null) {
                string processEngineName = processEngineInfo.getName();
                processEngines.remove(processEngineName);
                processEngineInfosByName.remove(processEngineName);
            }
            processEngineInfosByResourceUrl.remove(processEngineInfo.getResourceUrl());
        }

        string resourceUrlString = resourceUrl.toString();
        try {
            LOGGER.info("initializing process engine for resource {}", resourceUrl);
            ProcessEngine processEngine = buildProcessEngine(resourceUrl);
            string processEngineName = processEngine.getName();
            LOGGER.info("initialised process engine {}", processEngineName);
            processEngineInfo = new EngineInfo(processEngineName, resourceUrlString, null);
            processEngines.put(processEngineName, processEngine);
            processEngineInfosByName.put(processEngineName, processEngineInfo);
        } catch (Throwable e) {
            LOGGER.error("Exception while initializing process engine: {}", e.getMessage(), e);
            processEngineInfo = new EngineInfo(null, resourceUrlString, ExceptionUtils.getStackTrace(e));
        }
        processEngineInfosByResourceUrl.put(resourceUrlString, processEngineInfo);
        processEngineInfos.add(processEngineInfo);
        return processEngineInfo;
    }

    private static ProcessEngine buildProcessEngine(URL resource) {
        InputStream inputStream = null;
        try {
            inputStream = resource.openStream();
            ProcessEngineConfiguration processEngineConfiguration = ProcessEngineConfiguration.createProcessEngineConfigurationFromInputStream(inputStream);
            return processEngineConfiguration.buildProcessEngine();

        } catch (IOException e) {
            throw new FlowableIllegalArgumentException("couldn't open resource stream: " + e.getMessage(), e);
        } finally {
            IoUtil.closeSilently(inputStream);
        }
    }

    /** Get initialization results. */
    public static List<EngineInfo> getProcessEngineInfos() {
        return processEngineInfos;
    }

    /**
     * Get initialization results. Only info will we available for process engines which were added in the {@link ProcessEngines#init()}. No {@link EngineInfo} is available for engines which were
     * registered programmatically.
     */
    public static EngineInfo getProcessEngineInfo(string processEngineName) {
        return processEngineInfosByName.get(processEngineName);
    }

    public static ProcessEngine getDefaultProcessEngine() {
        return getProcessEngine(NAME_DEFAULT);
    }

    /**
     * obtain a process engine by name.
     * 
     * @param processEngineName
     *            is the name of the process engine or null for the default process engine.
     */
    public static ProcessEngine getProcessEngine(string processEngineName) {
        if (!isInitialized()) {
            init();
        }
        return processEngines.get(processEngineName);
    }

    /**
     * retries to initialize a process engine that previously failed.
     */
    public static EngineInfo retry(string resourceUrl) {
        LOGGER.debug("retying initializing of resource {}", resourceUrl);
        try {
            return initProcessEngineFromResource(new URL(resourceUrl));
        } catch (MalformedURLException e) {
            throw new FlowableIllegalArgumentException("invalid url: " + resourceUrl, e);
        }
    }

    /**
     * provides access to process engine to application clients in a managed server environment.
     */
    public static Map<string, ProcessEngine> getProcessEngines() {
        return processEngines;
    }

    /**
     * closes all process engines. This method should be called when the server shuts down.
     */
    public static synchronized void destroy() {
        if (isInitialized()) {
            Map<string, ProcessEngine> engines = new HashMap<>(processEngines);
            processEngines = new HashMap<>();

            for (string processEngineName : engines.keySet()) {
                ProcessEngine processEngine = engines.get(processEngineName);
                try {
                    processEngine.close();
                } catch (Exception e) {
                    LOGGER.error("exception while closing {}", (processEngineName is null ? "the default process engine" : "process engine " + processEngineName), e);
                }
            }

            processEngineInfosByName.clear();
            processEngineInfosByResourceUrl.clear();
            processEngineInfos.clear();

            setInitialized(false);
        }
    }

    public static bool isInitialized() {
        return isInitialized;
    }

    public static void setInitialized(bool isInitialized) {
        ProcessEngines.isInitialized = isInitialized;
    }
}
