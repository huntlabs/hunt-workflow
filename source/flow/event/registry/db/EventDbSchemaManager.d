///* Licensed under the Apache License, Version 2.0 (the "License");
// * you may not use this file except in compliance with the License.
// * You may obtain a copy of the License at
// *
// *      http://www.apache.org/licenses/LICENSE-2.0
// *
// * Unless required by applicable law or agreed to in writing, software
// * distributed under the License is distributed on an "AS IS" BASIS,
// * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// * See the License for the specific language governing permissions and
// * limitations under the License.
// */
//
//
//import flow.common.db.EngineDatabaseConfiguration;
//import flow.common.db.LiquibaseBasedSchemaManager;
//import flow.common.db.LiquibaseDatabaseConfiguration;
//import flow.common.db.SchemaManager;
//import flow.event.registry.EventRegistryEngineConfiguration;
//import flow.event.registry.util.CommandContextUtil;
//
//class EventDbSchemaManager extends LiquibaseBasedSchemaManager {
//
//    public static final String LIQUIBASE_CHANGELOG = "org/flowable/eventregistry/db/liquibase/flowable-eventregistry-db-changelog.xml";
//
//    public EventDbSchemaManager() {
//        super("eventregistry", LIQUIBASE_CHANGELOG, EventRegistryEngineConfiguration.LIQUIBASE_CHANGELOG_PREFIX);
//    }
//
//    @Override
//    protected LiquibaseDatabaseConfiguration getDatabaseConfiguration() {
//        return new EngineDatabaseConfiguration(CommandContextUtil.getEventRegistryConfiguration());
//    }
//
//    public void initSchema(EventRegistryEngineConfiguration eventRegistryConfiguration) {
//        initSchema(eventRegistryConfiguration.getDatabaseSchemaUpdate());
//    }
//
//    @Override
//    public void schemaCreate() {
//        getCommonSchemaManager().schemaCreate();
//        super.schemaCreate();
//    }
//
//    @Override
//    public void schemaDrop() {
//        try {
//            super.schemaDrop();
//        } catch (Exception e) {
//            logger.info("Error dropping event registry engine tables", e);
//        }
//
//        try {
//            getCommonSchemaManager().schemaDrop();
//        } catch (Exception e) {
//            logger.info("Error dropping common tables", e);
//        }
//    }
//
//    @Override
//    public String schemaUpdate() {
//        getCommonSchemaManager().schemaUpdate();
//        return super.schemaUpdate();
//    }
//
//    protected SchemaManager getCommonSchemaManager() {
//        return CommandContextUtil.getEventRegistryConfiguration().getCommonSchemaManager();
//    }
//
//}
