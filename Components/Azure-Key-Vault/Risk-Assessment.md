# Risk Assessment: Azure Key Vault

*Note: This is not the right risk assessment document. It will be replaced by the one for Key Vault.*

[[_TOC_]]

## Version Control

|Revision  |Update Date  |Created By  |Notes  |Approval Date | Approved By |
|--|--|--|--|--|--|
|1.0 | 23/01/21 | Frank Mogensen | Initial Assessment | 24/01/21 | Ronnie Bachmann
|1.1 | 25/01/21 | Frank Mogensen | SQL Server Auditing Enabled | 26/01/21 | Ronnie Bachmann

## Information

| Area | Description |
|--|--|
| Customer | OpsAI ApS. |
| Application Name | OpsAI |
| Application Owner | Darius Perminas |
| Application Type | PaaS |
| Application Criticality | High |
| Application Data Sensitivity | High |
| Regulatory Requirements | GDPR, ISO27001 |

## Location

| Area | Description |
|--|--|
| Azure Directory Name | OPSAI (OpsAI.com) |
| Azure Subscription Name | OpsAI vNext |
| Resource Group Name(s) | OpsAI|

## Assets

| NAME | TYPE | LOCATION |
|--|--|--|
|cloudeon-dev.cloudeon.com                        | DNS zone| Global |
|cloudeon-dev.opsai.com                           | DNS zone| Global |
|dev-assetmetadata (opsaiserver/dev-assetmetadata)| SQL database| West Europe |
|dev-opsai (opsaiserver/dev-opsai)                | SQL database| West Europe |
|dev-pricing (opsaiserver/dev-pricing)            | SQL database| West Europe |
|dev-scannerasset (opsaiserver/dev-scannerasset)  | SQL database| West Europe |
|opsai                                            | App Service| West Europe |
|opsai                                            | Application Insights| West Europe |
|opsaiplan                                        | App Service plan| West Europe |
|opsaiserver                                      | SQL server| West Europe |
|OpsAI-ws                                         | Log Analytics workspace | West Europe |

## Risk Assessment

### Asset: SQL Server

|Vulnerability | Existing Controls| Improvement Required| Severity
|--|--|--|--|
|Authentication|RBAC Enforced|An Azure Active Directory administrator should be provisioned for SQL servers|High|
|Access|None|Role based access elevation should be Enabled|Medium|
|Security Logging|Auditing Enabled on SQL server|None|Low
|Data Encryption at rest|None|SQL servers should use customer-managed keys to encrypt data at rest|Low|
|Data Encryption in Motion|None|Enforcement of SQL TLS should be enabled|High|
|Keys Stored in a KeyStore|None|Customer Managed Keys should be placed in key store|High|
|Vulnerability Protection|None|Vulnerability assessment should be enabled on your SQL servers|High|
|Network protection|None|DDOS protection should be enabled or Public Access should be denied|None|
|Disaster Recovery|None|Enforce Backup Policy and LTR|Low|
|Business Continuity|None|A Failover Group should be established|Low|
|Regulatory Compliance GDPR|Platform Enforcement of Asset Creation in EU Regions|None|High|
|Regulatory Compliance ISO27001|None|All Policies for ISO Compliance should be applied|High|

### Asset: SQL Database

| Vulnerability | Existing Controls| Improvement Required | Severity |
|--|--|--|--|
|Authentication|-|-|-|
|Access|-|-|-|
|Security Logging|-|-|-|
|Data Encryption at rest|-|-|-|
|Data Encryption in Motion|-|-|-|
|Keys Stored in a KeyStore|-|-|-|
|Vulnerability Protection|-|-|-|
|Network protection|-|-|-|
|Disaster Recovery|-|-|-|
|Business Continuity|-|-|-|
|Regulatory Compliance GDPR|-|-|-|
|Regulatory Compliance ISO27001|-|-|-|
