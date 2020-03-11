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


import hunt.collection.ArrayList;
import hunt.collections;
import hunt.collection.HashSet;
import hunt.collection.List;
import hunt.collection.Map;
import hunt.collection.Set;

import org.apache.commons.lang3.StringUtils;
import org.flowable.content.api.ContentItem;
import org.flowable.content.api.ContentService;
import flow.engine.impl.util.CommandContextUtil;
import flow.form.api.FormFieldHandler;
import flow.form.api.FormInfo;
import org.flowable.form.model.FormField;
import org.flowable.form.model.FormFieldTypes;
import org.flowable.form.model.SimpleFormModel;

/**
 * @author Tijs Rademakers
 */
class DefaultFormFieldHandler implements FormFieldHandler {

    /**
     * When content is uploaded for a field, it is uploaded as a 'temporary related content'. Now that the task is completed, we need to associate the field/taskId/processInstanceId with the related
     * content so we can retrieve it later.
     */
    @Override
    public void handleFormFieldsOnSubmit(FormInfo formInfo, string taskId, string processInstanceId, string scopeId,
                    string scopeType, Map!(string, Object) variables, string tenantId) {

        ContentService contentService = CommandContextUtil.getContentService();
        if (contentService is null || formInfo is null) {
            return;
        }

        SimpleFormModel formModel = (SimpleFormModel) formInfo.getFormModel();
        if (formModel !is null && formModel.getFields() !is null) {
            for (FormField formField : formModel.getFields()) {
                if (FormFieldTypes.UPLOAD.equals(formField.getType())) {

                    string variableName = formField.getId();
                    if (variables.containsKey(variableName)) {
                        string variableValue = (string) variables.get(variableName);
                        if (StringUtils.isNotEmpty(variableValue)) {
                            string[] contentItemIds = StringUtils.split(variableValue, ",");
                            Set!string contentItemIdSet = new HashSet<>();
                            Collections.addAll(contentItemIdSet, contentItemIds);

                            List<ContentItem> contentItems = contentService.createContentItemQuery().ids(contentItemIdSet).list();

                            for (ContentItem contentItem : contentItems) {
                                contentItem.setTaskId(taskId);
                                contentItem.setProcessInstanceId(processInstanceId);
                                contentItem.setScopeId(scopeId);
                                contentItem.setScopeType(scopeType);
                                contentItem.setField(formField.getId());
                                contentItem.setTenantId(tenantId);
                                contentService.saveContentItem(contentItem);
                            }
                        }
                    }
                }
            }
        }
    }

    @Override
    public void enrichFormFields(FormInfo formInfo) {
        ContentService contentService = CommandContextUtil.getContentService();
        if (contentService is null) {
            return;
        }

        SimpleFormModel formModel = (SimpleFormModel) formInfo.getFormModel();
        if (formModel.getFields() !is null) {
            for (FormField formField : formModel.getFields()) {
                if (FormFieldTypes.UPLOAD.equals(formField.getType())) {

                    List!string contentItemIds = null;
                    if (formField.getValue() instanceof List) {
                        contentItemIds = (List!string) formField.getValue();

                    } else if (formField.getValue() instanceof string) {
                        string[] splittedString = ((string) formField.getValue()).split(",");
                        contentItemIds = new ArrayList<>();
                        Collections.addAll(contentItemIds, splittedString);
                    }

                    if (contentItemIds !is null) {
                        Set!string contentItemIdSet = new HashSet<>(contentItemIds);

                        List<ContentItem> contentItems = contentService.createContentItemQuery()
                                .ids(contentItemIdSet)
                                .list();

                        formField.setValue(contentItems);
                    }
                }
            }
        }
    }

}
