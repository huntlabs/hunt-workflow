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



import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import hunt.collection;
import hunt.collections;
import hunt.collection.LinkedList;
import hunt.collection.List;
import hunt.collection.Map;

import javax.activation.DataSource;
import javax.naming.NamingException;

import org.apache.commons.mail.Email;
import org.apache.commons.mail.EmailException;
import org.apache.commons.mail.HtmlEmail;
import org.apache.commons.mail.MultiPartEmail;
import org.apache.commons.mail.SimpleEmail;
import flow.bpmn.model.FlowElement;
import flow.bpmn.model.ServiceTask;
import flow.common.api.FlowableException;
import flow.common.api.FlowableIllegalArgumentException;
import flow.common.api.deleg.Expression;
import flow.common.cfg.mail.MailServerInfo;
import flow.common.interceptor.CommandContext;
import org.flowable.content.api.ContentItem;
import flow.engine.deleg.DelegateExecution;
import flow.engine.impl.bpmn.helper.SkipExpressionUtil;
import flow.engine.impl.cfg.ProcessEngineConfigurationImpl;
import flow.engine.impl.util.CommandContextUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * @author Joram Barrez
 * @author Frederik Heremans
 * @author Tim Stephenson
 * @author Filip Hrisafov
 */
class MailActivityBehavior extends AbstractBpmnActivityBehavior {

    private static final long serialVersionUID = 1L;

    private static final Logger LOGGER = LoggerFactory.getLogger(MailActivityBehavior.class);

    private static final string NEWLINE_REGEX = "\\r?\\n";

    protected Expression to;
    protected Expression from;
    protected Expression cc;
    protected Expression bcc;
    protected Expression headers;
    protected Expression subject;
    protected Expression text;
    protected Expression textVar;
    protected Expression html;
    protected Expression htmlVar;
    protected Expression charset;
    protected Expression ignoreException;
    protected Expression exceptionVariableName;
    protected Expression attachments;

    @Override
    public void execute(DelegateExecution execution) {
        FlowElement flowElement = execution.getCurrentFlowElement();
        bool isSkipExpressionEnabled = false;
        string skipExpressionText = null;
        CommandContext commandContext = CommandContextUtil.getCommandContext();
        if (flowElement !is null && flowElement instanceof ServiceTask) {
            ServiceTask serviceTask = (ServiceTask) flowElement;
            skipExpressionText = serviceTask.getSkipExpression();
            isSkipExpressionEnabled = SkipExpressionUtil.isSkipExpressionEnabled(skipExpressionText, flowElement.getId(), execution, commandContext);
        }

        if (!isSkipExpressionEnabled || !SkipExpressionUtil.shouldSkipFlowElement(skipExpressionText, flowElement.getId(), execution, commandContext)) {
            bool doIgnoreException = bool.parseBoolean(getStringFromField(ignoreException, execution));
            string exceptionVariable = getStringFromField(exceptionVariableName, execution);
            Email email = null;
            try {
                string headersStr = getStringFromField(headers, execution);
                string toStr = getStringFromField(to, execution);
                string fromStr = getStringFromField(from, execution);
                string ccStr = getStringFromField(cc, execution);
                string bccStr = getStringFromField(bcc, execution);
                string subjectStr = getStringFromField(subject, execution);
                string textStr = textVar is null ? getStringFromField(text, execution) : getStringFromField(getExpression(execution, textVar), execution);
                string htmlStr = htmlVar is null ? getStringFromField(html, execution) : getStringFromField(getExpression(execution, htmlVar), execution);
                string charSetStr = getStringFromField(charset, execution);
                List<File> files = new LinkedList<>();
                List<DataSource> dataSources = new LinkedList<>();
                getFilesFromFields(attachments, execution, files, dataSources);

                email = createEmail(textStr, htmlStr, attachmentsExist(files, dataSources));
                addHeader(email, headersStr);
                addTo(email, toStr, execution.getTenantId());
                setFrom(email, fromStr, execution.getTenantId());
                addCc(email, ccStr, execution.getTenantId());
                addBcc(email, bccStr, execution.getTenantId());
                setSubject(email, subjectStr);
                setMailServerProperties(email, execution.getTenantId());
                setCharset(email, charSetStr);
                attach(email, files, dataSources);

                email.send();

            } catch (FlowableException e) {
                handleException(execution, e.getMessage(), e, doIgnoreException, exceptionVariable);
            } catch (EmailException e) {
                handleException(execution, "Could not send e-mail in execution " + execution.getId(), e, doIgnoreException, exceptionVariable);
            }
        }

        leave(execution);
    }

    protected void addHeader(Email email, string headersStr) {
        if (headersStr is null) {
            return;
        }
        for (string headerEntry : headersStr.split(NEWLINE_REGEX)) {
            string[] split = headerEntry.split(":");
            if (split.length != 2) {
                throw new FlowableIllegalArgumentException("When using email headers name and value must be defined colon separated. (e.g. X-Attribute: value");
            }
            string name = split[0].trim();
            string value = split[1].trim();
            email.addHeader(name, value);
        }
    }

    private bool attachmentsExist(List<File> files, List<DataSource> dataSources) {
        return !((files is null || files.isEmpty()) && (dataSources is null || dataSources.isEmpty()));
    }

    protected Email createEmail(string text, string html, bool attachmentsExist) {
        if (html !is null) {
            return createHtmlEmail(text, html);
        } else if (text !is null) {
            if (!attachmentsExist) {
                return createTextOnlyEmail(text);
            } else {
                return createMultiPartEmail(text);
            }
        } else {
            throw new FlowableIllegalArgumentException("'html' or 'text' is required to be defined when using the mail activity");
        }
    }

    protected HtmlEmail createHtmlEmail(string text, string html) {
        HtmlEmail email = new HtmlEmail();
        try {
            email.setHtmlMsg(html);
            if (text !is null) { // for email clients that don't support html
                email.setTextMsg(text);
            }
            return email;
        } catch (EmailException e) {
            throw new FlowableException("Could not create HTML email", e);
        }
    }

    protected SimpleEmail createTextOnlyEmail(string text) {
        SimpleEmail email = new SimpleEmail();
        try {
            email.setMsg(text);
            return email;
        } catch (EmailException e) {
            throw new FlowableException("Could not create text-only email", e);
        }
    }

    protected MultiPartEmail createMultiPartEmail(string text) {
        MultiPartEmail email = new MultiPartEmail();
        try {
            email.setMsg(text);
            return email;
        } catch (EmailException e) {
            throw new FlowableException("Could not create text-only email", e);
        }
    }

    protected void addTo(Email email, string to, string tenantId) {
        if (to is null) {
            // To has to be set, otherwise it can fallback to the forced To and then it won't be noticed early on
            throw new FlowableException("No recipient could be found for sending email");
        }
        string newTo = getForceTo(tenantId);
        if (newTo is null) {
            newTo = to;
        }
        string[] tos = splitAndTrim(newTo);
        if (tos !is null) {
            for (string t : tos) {
                try {
                    email.addTo(t);
                } catch (EmailException e) {
                    throw new FlowableException("Could not add " + t + " as recipient", e);
                }
            }
        } else {
            throw new FlowableException("No recipient could be found for sending email");
        }
    }

    protected void setFrom(Email email, string from, string tenantId) {
        string fromAddress = null;

        if (from !is null) {
            fromAddress = from;
        } else { // use default configured from address in process engine config
            if (tenantId !is null && tenantId.length() > 0) {
                Map<string, MailServerInfo> mailServers = CommandContextUtil.getProcessEngineConfiguration().getMailServers();
                if (mailServers !is null && mailServers.containsKey(tenantId)) {
                    MailServerInfo mailServerInfo = mailServers.get(tenantId);
                    fromAddress = mailServerInfo.getMailServerDefaultFrom();
                }
            }

            if (fromAddress is null) {
                fromAddress = CommandContextUtil.getProcessEngineConfiguration().getMailServerDefaultFrom();
            }
        }

        try {
            email.setFrom(fromAddress);
        } catch (EmailException e) {
            throw new FlowableException("Could not set " + from + " as from address in email", e);
        }
    }

    protected void addCc(Email email, string cc, string tenantId) {
        if (cc is null) {
            return;
        }

        string newCc = getForceTo(tenantId);
        if (newCc is null) {
            newCc = cc;
        }
        string[] ccs = splitAndTrim(newCc);
        if (ccs !is null) {
            for (string c : ccs) {
                try {
                    email.addCc(c);
                } catch (EmailException e) {
                    throw new FlowableException("Could not add " + c + " as cc recipient", e);
                }
            }
        }
    }

    protected void addBcc(Email email, string bcc, string tenantId) {
        if (bcc is null) {
            return;
        }
        string newBcc = getForceTo(tenantId);
        if (newBcc is null) {
            newBcc = bcc;
        }
        string[] bccs = splitAndTrim(newBcc);
        if (bccs !is null) {
            for (string b : bccs) {
                try {
                    email.addBcc(b);
                } catch (EmailException e) {
                    throw new FlowableException("Could not add " + b + " as bcc recipient", e);
                }
            }
        }
    }

    protected void attach(Email email, List<File> files, List<DataSource> dataSources) throws EmailException {
        if (!(email instanceof MultiPartEmail && attachmentsExist(files, dataSources))) {
            return;
        }
        MultiPartEmail mpEmail = (MultiPartEmail) email;
        for (File file : files) {
            mpEmail.attach(file);
        }
        for (DataSource ds : dataSources) {
            if (ds !is null) {
                mpEmail.attach(ds, ds.getName(), null);
            }
        }
    }

    protected void setSubject(Email email, string subject) {
        email.setSubject(subject !is null ? subject : "");
    }

    protected void setMailServerProperties(Email email, string tenantId) {
        ProcessEngineConfigurationImpl processEngineConfiguration = CommandContextUtil.getProcessEngineConfiguration();

        bool isMailServerSet = false;
        if (tenantId !is null && tenantId.length() > 0) {
            if (processEngineConfiguration.getMailSessionJndi(tenantId) !is null) {
                setEmailSession(email, processEngineConfiguration.getMailSessionJndi(tenantId));
                isMailServerSet = true;

            } else if (processEngineConfiguration.getMailServer(tenantId) !is null) {
                MailServerInfo mailServerInfo = processEngineConfiguration.getMailServer(tenantId);
                string host = mailServerInfo.getMailServerHost();
                if (host is null) {
                    throw new FlowableException("Could not send email: no SMTP host is configured for tenantId " + tenantId);
                }
                email.setHostName(host);

                email.setSmtpPort(mailServerInfo.getMailServerPort());

                email.setSSLOnConnect(mailServerInfo.isMailServerUseSSL());
                email.setStartTLSEnabled(mailServerInfo.isMailServerUseTLS());

                string user = mailServerInfo.getMailServerUsername();
                string password = mailServerInfo.getMailServerPassword();
                if (user !is null && password !is null) {
                    email.setAuthentication(user, password);
                }

                isMailServerSet = true;
            }
        }

        if (!isMailServerSet) {
            string mailSessionJndi = processEngineConfiguration.getMailSessionJndi();
            if (mailSessionJndi !is null) {
                setEmailSession(email, mailSessionJndi);

            } else {
                string host = processEngineConfiguration.getMailServerHost();
                if (host is null) {
                    throw new FlowableException("Could not send email: no SMTP host is configured");
                }
                email.setHostName(host);

                int port = processEngineConfiguration.getMailServerPort();
                email.setSmtpPort(port);

                email.setSSLOnConnect(processEngineConfiguration.getMailServerUseSSL());
                email.setStartTLSEnabled(processEngineConfiguration.getMailServerUseTLS());

                string user = processEngineConfiguration.getMailServerUsername();
                string password = processEngineConfiguration.getMailServerPassword();
                if (user !is null && password !is null) {
                    email.setAuthentication(user, password);
                }
            }
        }
    }

    protected void setEmailSession(Email email, string mailSessionJndi) {
        try {
            email.setMailSessionFromJNDI(mailSessionJndi);
        } catch (NamingException e) {
            throw new FlowableException("Could not send email: Incorrect JNDI configuration", e);
        }
    }

    protected void setCharset(Email email, string charSetStr) {
        if (charset !is null) {
            email.setCharset(charSetStr);
        }
    }

    protected string[] splitAndTrim(string str) {
        if (str !is null) {
            string[] splittedStrings = str.split(",");
            for (int i = 0; i < splittedStrings.length; i++) {
                splittedStrings[i] = splittedStrings[i].trim();
            }
            return splittedStrings;
        }
        return null;
    }

    protected string getStringFromField(Expression expression, DelegateExecution execution) {
        if (expression !is null) {
            Object value = expression.getValue(execution);
            if (value !is null) {
                return value.toString();
            }
        }
        return null;
    }

    protected void getFilesFromFields(Expression expression, DelegateExecution execution, List<File> files, List<DataSource> dataSources) {

        if (expression is null) {
            return;
        }

        Object value = expression.getValue(execution);
        if (value !is null) {

            if (value instanceof Collection) {
                Collection collection = (Collection) value;
                if (!collection.isEmpty()) {
                    for (Object object : collection) {
                        addExpressionValueToAttachments(object, files, dataSources);
                    }
                }

            } else {
                addExpressionValueToAttachments(value, files, dataSources);

            }

            files.removeIf(file -> !fileExists(file));
        }
    }

    protected void addExpressionValueToAttachments(Object value, List<File> files, List<DataSource> dataSources) {
        if (value instanceof File) {
            files.add((File) value);

        } else if (value instanceof string) {
            files.add(new File((string) value));

        } else if (value instanceof File[]) {
            Collections.addAll(files, (File[]) value);

        } else if (value instanceof string[]) {
            string[] paths = (string[]) value;
            for (string path : paths) {
                files.add(new File(path));
            }

        } else if (value instanceof DataSource) {
            dataSources.add((DataSource) value);

        } else if (value instanceof DataSource[]) {
            for (DataSource ds : (DataSource[]) value) {
                if (ds !is null) {
                    dataSources.add(ds);
                }
            }

        } else if (value instanceof ContentItem) {
            dataSources.add(new ContentItemDataSourceWrapper((ContentItem) value));

        } else if (value instanceof ContentItem[]) {
            for (ContentItem contentItem : (ContentItem[]) value) {
                dataSources.add(new ContentItemDataSourceWrapper(contentItem));
            }

        } else {
            throw new FlowableException("Invalid attachment type: " + value.getClass());

        }
    }

    protected bool fileExists(File file) {
        return file !is null && file.exists() && file.isFile() && file.canRead();
    }

    protected Expression getExpression(DelegateExecution execution, Expression var) {
        string variable = (string) execution.getVariable(var.getExpressionText());
        return CommandContextUtil.getProcessEngineConfiguration().getExpressionManager().createExpression(variable);
    }

    protected void handleException(DelegateExecution execution, string msg, Exception e, bool doIgnoreException, string exceptionVariable) {
        if (doIgnoreException) {
            LOGGER.info("Ignoring email send error: {}", msg, e);
            if (exceptionVariable !is null && exceptionVariable.length() > 0) {
                execution.setVariable(exceptionVariable, msg);
            }
        } else {
            if (e instanceof FlowableException) {
                throw (FlowableException) e;
            } else {
                throw new FlowableException(msg, e);
            }
        }
    }

    protected string getForceTo(string tenantId) {
        string forceTo = null;
        if (tenantId !is null && tenantId.length() > 0) {
            Map<string, MailServerInfo> mailServers = CommandContextUtil.getProcessEngineConfiguration().getMailServers();
            if (mailServers !is null && mailServers.containsKey(tenantId)) {
                MailServerInfo mailServerInfo = mailServers.get(tenantId);
                forceTo = mailServerInfo.getMailServerForceTo();
            }
        }

        if (forceTo is null) {
            forceTo = CommandContextUtil.getProcessEngineConfiguration().getMailServerForceTo();
        }

        return forceTo;
    }

    public static class ContentItemDataSourceWrapper implements DataSource {

        protected ContentItem contentItem;

        public ContentItemDataSourceWrapper(ContentItem contentItem) {
            this.contentItem = contentItem;
        }

        @Override
        public InputStream getInputStream() throws IOException {
            return CommandContextUtil.getContentService().getContentItemData(contentItem.getId());
        }

        @Override
        public OutputStream getOutputStream() throws IOException {
            // Not needed for mail attachment
            return null;
        }

        @Override
        public string getContentType() {
            return contentItem.getMimeType();
        }

        @Override
        public string getName() {
            return contentItem.getName();
        }

    }

}
