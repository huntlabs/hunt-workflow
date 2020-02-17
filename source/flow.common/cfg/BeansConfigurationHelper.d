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
 
module flow.common.cfg.BeansConfigurationHelper;
 
 


//import flow.common.runtime.AbstractEngineConfiguration;
//
//
///**
// * @author Tom Baeyens
// */
//class BeansConfigurationHelper {
//
//    public static AbstractEngineConfiguration parseEngineConfiguration(Resource springResource, string beanName) {
//        DefaultListableBeanFactory beanFactory = new DefaultListableBeanFactory();
//        XmlBeanDefinitionReader xmlBeanDefinitionReader = new XmlBeanDefinitionReader(beanFactory);
//        xmlBeanDefinitionReader.setValidationMode(XmlBeanDefinitionReader.VALIDATION_XSD);
//        xmlBeanDefinitionReader.loadBeanDefinitions(springResource);
//
//        // Check non singleton beans for types
//        // Do not eagerly initialize FactorBeans when getting BeanFactoryPostProcessor beans
//        Collection<BeanFactoryPostProcessor> factoryPostProcessors = beanFactory.getBeansOfType(BeanFactoryPostProcessor.class, true, false).values();
//        if (factoryPostProcessors.isEmpty()) {
//            factoryPostProcessors = Collections.singleton(new PropertyPlaceholderConfigurer());
//        }
//        for (BeanFactoryPostProcessor factoryPostProcessor : factoryPostProcessors) {
//            factoryPostProcessor.postProcessBeanFactory(beanFactory);
//        }
//
//        AbstractEngineConfiguration engineConfiguration = (AbstractEngineConfiguration) beanFactory.getBean(beanName);
//        engineConfiguration.setBeans(new SpringBeanFactoryProxyMap(beanFactory));
//        return engineConfiguration;
//    }
//
//    public static AbstractEngineConfiguration parseEngineConfigurationFromInputStream(InputStream inputStream, string beanName) {
//        Resource springResource = new InputStreamResource(inputStream);
//        return parseEngineConfiguration(springResource, beanName);
//    }
//
//    public static AbstractEngineConfiguration parseEngineConfigurationFromResource(string resource, string beanName) {
//        Resource springResource = new ClassPathResource(resource);
//        return parseEngineConfiguration(springResource, beanName);
//    }
//
//}
