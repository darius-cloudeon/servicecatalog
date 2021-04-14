ID

Title	Security controls and design decisions for KVs
Date	25-01-2021
Subject Area	Security
Decision Statement	
Status	Proposed
Problem Statement	The CCoE wants to improve the security baseline of KVs to
-	Improve compliance with applicable security standards. 
-	Implement security best practices and design recommendations. 
-	Reduce risk of security incidents (intentional and accidental) such as deletion of KVs (or specific objects within), unauthorized access, etc. 
Assumptions	-	
Constraints	As of 27/01/2021, RBAC permission model for KVs are still in public preview and can offer granular object-level permission to specific keys, secrets or certificates. The Vault access policy that is currently available does not allow this granular level of access control. 



Motivation	
Alternative 1

Redundancy and high availability	Security design decision: 
Key Vaults should be replicated in another datacenter and/or region to ensure high availability in case of a datacenter failure.

Security Control: None required

Justification: 
On Azure, Key vaults are replicated by default within the region and to a secondary region at least 150 miles away, but within the same geography. This offers high durability of keys and secrets. In addition, Key Vault maintains availability in disaster scenarios and will automatically fail over requests to a paired region without any intervention from a user.

Reference:


Soft-delete	Security design decision: 
Soft-delete is enabled on all Key Vaults to tackle malicious or accidental deletion.

Security Control: 
-	None required for KVs that will be created in the future
-	Create a custom policy to audit existing KVs in these environments that do not have soft-delete enabled
-	Enable soft-delete on older KVs in pre-prod or prod environments. 

Justification: 
-	Soft-delete is now enabled by default on all Key Vaults. The feature to disable soft-delete has been deprecated by Azure in Dec 2020.
-	Breaking change: the ability to opt out of soft-delete will be deprecated soon. Azure Key Vault users and administrators should enable soft-delete on their key vaults immediately. 

Reference:
Azure Security Benchmark
Cloud Adoption Framework 


Retention period	Security design decision: 
Retention period is set for Key Vaults in the soft-deleted state to aid KV (including individual KV objects) recovery.

Security Control: 
Sandbox	Dev and Test	Pre-Prod and Prod
Configure the Retention Period to the minimum -7 days.	Configure the retention period to the maximum - 90 days.	Configure the retention period to the maximum - 90 days.

Justification: 
-	Retention period applies both to KVs and to the individual objects (keys, certificates, secrets) within.
-	Retention period can be configured to between 7 – 90 days, while 90 days is set as default and is also the maximum.
-	Key Vaults pricing is based on per 10.000 operations. Even though the object exists while in soft-delete, no operations can be performed and hence no cost implication for using the maximum retention period for soft-delete, specifically for environments excluding the Sandbox. 
-	For Sandbox SEs, it serves no business purpose to have long retention periods and to allow for the soft-deleted data to be purged automatically at the end of this retention period. 

Reference:
Cloud Adoption Framework 

Purge Protection	Security design decision: 
Key Vaults must be secured with purge protection to prevent permanent deletion of KV or individual objects during retention period.

Security Control: 
Sandbox	Dev and Test	Pre-Prod and Prod
Purge protection is disabled to allow cleanup of Sandbox environments as per CCoE policy	Assign AZ Policy - Key vaults should have purge protection enabled with Policy Enforcement set to Enabled and Policy Effect set to Audit
	Assign AZ Policy - Key vaults should have purge protection enabled with Policy Enforcement set to Enabled and Policy Effect set to Deny


Justification: 
Purge protection helps protect against insider attacks by enforcing a mandatory retention period for soft deleted key vaults.

Reference:
Azure Security Benchmark
CIS Microsoft Azure Foundations Benchmark
Cloud Adoption Framework 


Logging and Monitoring	Security design decision: 
Diagnostics logs in Key Vaults must be enabled and log streams must be sent to Log Analytics workspace to monitor how and when Key Vaults are accessed, and by whom.

Security Control: 
-	Assign AZ Policy - Diagnostic logs in Key Vault should be enabled with Policy Enforcement set to Enabled, Policy Effect set to AuditIfNotExists and Retention Period set to 365.

-	Assign AZ Policy – Deploy Diagnostic Settings for Key Vault to Log Analytics workspace with Policy Enforcement set to Enabled, Policy Effect set to DeployIfNotExists, Enable metrics set to True and Enable Logs set to True.

Justification: 
-	Enabling of diagnostic logs can help recreate activity trails to use for investigation purposes when a security incident occurs or when network is compromised.
-	ACME INC.’s Standard for Logging and Monitoring - 4.1.1 Requirements for event logging states - The standard for logging and monitoring applies to all places where IT is used, for example, but not only, network components, station equipment, servers, workstations, and software. It also covers all use of cloud computing or other forms of IT hosting or outsourcing, where ACME INC. is not the owner of the physical sites.
-	Retention period for diagnostic logs is not stated in the ACME INC. standard documents, although general best practices suggest retaining logs for at least 365 days (which is also the default on Azure).
-	Log Analytics allow for complex querying and analysis of logs and the diagnostic settings for Key Vault to stream to a regional Log Analytics workspace should be configured.

Reference:
[CSF.F09] Security Monitoring and Correlation Solution
ACME INC.’s Standard for Logging and Monitoring - 4.1.1 Requirements for event logging
Azure Security Benchmark
CIS Microsoft Azure Foundations Benchmark
Cloud Adoption Framework 

Naming Convention	Security design decision: 
Key Vault naming convention/logic must introduce random string to ensure that KV names are globally unique.

Security Control: 
Introduce randomness in the naming convention/logic of KVs using terraform random provider. 

Justification: 
It will not be possible to reuse the name of a key vault or key vault object that exists in the soft-deleted state. A name-conflict will result in the resource not being created. This is particularly relevant when KV names are set programmatically.

Reference:


Access Control at Data Plane	Security design decision: 
-	Key Vault access policy permission model will be used to grant access to the data plane. 
-	The principle of least privilege must be applied when providing Service Principals access to Key Vaults.
-	Migrate to the RBAC permission model for KVs when Microsoft announces the general availability of this feature as RBAC can offer granular object-level permissions to specific keys, secrets or certificates. 

Security Control: 
-	Restrict purge permissions (needs to be granted explicitly) for Service Principals by default. 
-	Grant purge access policy permissions (Privileged Operations to purge or recover) to the security/service principal through Privileged Identity Management (PIM) with just in time access. 

Justification: 
-	Only a specifically privileged service principal may forcibly delete a key vault or key vault object by issuing a delete command on the corresponding proxy resource.
-	ACME INC.’ Access Control Standard - 4.2 Role-based access control states -Role-based access management ensures efficient management and security of user account rights there.

Reference:
[CSF.F02] IAM on all Accounts
ACME INC.’ Access Control Standard - 4.2 Role-based access control states
Cloud Adoption Framework 

Resource Locks	Security design decision: 
Protect Key Vaults with a resource lock to prevent accidental deletion or modification.

Security Control: 
Create and assign a custom role that grants the Service Principal permissions to Microsoft.Authorization/* or Microsoft.Authorization/locks/* actions to create or delete locks.

Justification: 
-	Locks on critical resource can help prevent accidental deletion or modification of these resources.
-	Of the built-in roles, only Owner and User Access Administrator are granted access to the necessary actions that allow for the creation or deletion of locks. 
-	The SP’s contributor role currently limits it ability to create or delete locks.

Reference:
[CSF.F02] IAM on all Accounts


Network Security	Security design decision: 
Audit Key Vault that not configured to use a virtual network service endpoint and flag non-compliant Key Vaults for further architectural design consideration by the respective ACME INC. application team.

Security Control: 
-	Assign AZ Policy – Key Vault should use a virtual network service endpoint with Policy Enforcement set to Enabled and Policy Effect set to Audit

Justification: 
CAF recommends Key Vaults to use virtual network service endpoint to restrict access to specific Virtual Networks, IPv4 Addresses and Ranges and/or to Trusted Microsoft Services.


Reference:
Cloud Adoption Framework 
[CSF.C07] Micro-segmentation
Azure Security Benchmark

Rotation of Keys 	Security design decision: 
Keys, certificates and secrets should have a maximum validity period and must be rotated periodically.

Security Control: 
Sandbox	Dev and Test	Pre-Prod and Prod
No controls for the Sandbox environment	Certificates
Assign AZ Policy - Certificates should have the specified maximum validity period with Policy Enforcement set to Enabled, Policy Effect set to Audit and Maximum validity in months set to 36.

Assign AZ Policy -Certificates should not expire within the specified number of days with Policy Enforcement set to Enabled, Policy Effect set to Audit and Days to Expire set to 180.

Keys
Assign AZ Policy - Keys should have the specified maximum validity period with Policy Enforcement set to Enabled, Policy Effect set to Audit and Maximum validity period in days set to 365.

Assign AZ Policy - Keys should have more than the specified number of days before expiration with Policy Enforcement set to Enabled, Policy Effect set to Audit and The minimum days before expiration set to 60.

Assign AZ Policy - Key Vault keys should have an expiration date with Policy Enforcement set to Enabled, Policy Effect set to Audit.

Secrets
Assign AZ Policy - Secrets should have the specified maximum validity period with Policy Enforcement set to Enabled, Policy Effect set to Audit and Maximum validity period in days set to 120.

Assign AZ Policy - Secrets should have more than the specified number of days before expiration with Policy Enforcement set to Enabled, Policy Effect set to Audit and The minimum days before expiration set to 60.

Assign AZ Policy - Key Vault secrets should have an expiration date with Policy Enforcement set to Enabled, Policy Effect set to Audit.

	Certificates
Assign AZ Policy - Certificates should have the specified maximum validity period with Policy Enforcement set to Enabled, Policy Effect set to Deny and Maximum validity in months set to 36.

Assign AZ Policy -Certificates should not expire within the specified number of days with Policy Enforcement set to Enabled, Policy Effect set to Deny and Days to Expire set to 180.

Keys
Assign AZ Policy - Keys should have the specified maximum validity period with Policy Enforcement set to Enabled, Policy Effect set to Deny and Maximum validity period in days set to 365.

Assign AZ Policy - Keys should have more than the specified number of days before expiration with Policy Enforcement set to Enabled, Policy Effect set to Deny and The minimum days before expiration set to 60.

Assign AZ Policy - Key Vault keys should have an expiration date with Policy Enforcement set to Enabled, Policy Effect set to Deny.

Secrets
Assign AZ Policy - Secrets should have the specified maximum validity period with Policy Enforcement set to Enabled, Policy Effect set to Deny and Maximum validity period in days set to 120.

Assign AZ Policy - Secrets should have more than the specified number of days before expiration with Policy Enforcement set to Enabled, Policy Effect set to Deny and The minimum days before expiration set to 60.

Assign AZ Policy - Key Vault secrets should have an expiration date with Policy Enforcement set to Enabled, Policy Effect set to Deny.



Justification: 
-	Periodic rotation of keys, certificates and secrets is considered a good security practice.
-	If a key, certificate or secret is too close to expiration, an organizational delay to rotate them may result in an outage. They should be rotated at a specified number of days prior to expiration to provide sufficient time to react to a failure.
-	Microsoft recommends that policies related to the monitoring of expiry of keys, certificates and secrets is applied multiple times with different expiration thresholds, for example, at 180, 90, 60, and 30-day thresholds.
-	Cryptographic keys and secrete should have a defined expiration date and not be permanent. Keys or secrets that are valid forever provide a potential attacker with more time to compromise them. It is a recommended security practice to set expiration dates on cryptographic keys and secrets.


Reference:
[CSF.H04] Managed Keys
Cloud Adoption Framework 

Key Type	Security design decision: 
Restrict key types allowed for certificates to RSA or EC to meet organizational compliance requirements.

Security Control: 
-	Assign AZ Policy – Certificates should use allowed key types with Policy Enforcement set to Enabled, Policy Effect set to Deny and Allowed key types set to RSA; EC

Justification: 
ACME INC.’ Standard for Encryption - 4.2.3 Encryption Algorithms and Key Sizes, mandates the use of one of the following algorithms – AES, RSA, DL, ECC, and SHA 

Reference:
[CSF.H04] Managed Keys
ACME INC.’ Standard for Encryption - 4.2.3 Encryption Algorithms and Key Sizes

Key Sizes	Security design decision: 
Restrict minimum RSA key size to 2048 bits and EC key size to 512 bits to meet organizational compliance requirements.

Security Control: 
-	Assign AZ Policy – Keys using RSA cryptography should have a specified minimum key size with Policy Enforcement set to Enabled, Policy Effect set to Deny and Minimum Key Size set to 2048

-	Assign AZ Policy – Keys using elliptic curve cryptography should have the specified curve names with Policy Enforcement set to Enabled, Policy Effect set to Deny and Allowed elliptic curve names set to P-521

-	Assign AZ Policy – Certificates using RSA cryptography should have a specified minimum key size with Policy Enforcement set to Enabled, Policy Effect set to Deny and Minimum RSA Key Size set to 2048


Justification: 
-	Use of RSA keys with small key sizes is not a secure practice and doesn't meet many industry certification requirements. 
-	ACME INC.’s Standard for Encryption - 4.2.3 Encryption Algorithms and Key Sizes, mandates the use of RSA keys with a minimum size of 2048 bits and EC Keys with a minimum size of 512 bits (although this should have read 521 bits).

Reference:
[CSF.H04] Managed Keys
ACME INC.’s Standard for Encryption - 4.2.3 Encryption Algorithms and Key Sizes244


Cloud Adoption Framework General Design recommendations for KV
-	Provision Azure Key Vault with the soft delete and purge policies enabled to allow retention protection for deleted objects.
-	Use the platform-central Azure Monitor Log Analytics workspace to audit key, certificate, and secret usage within each instance of Key Vault.
-	Follow a least privilege model by limiting authorization to permanently delete keys, secrets, and certificates to specialized custom Azure Active Directory (Azure AD) roles.
-	Automate the certificate management and renewal process with public certificate authorities to ease administration.
-	Establish an automated process for key and certificate rotation.
-	Enable firewall and virtual network service endpoint on the vault to control access to the key vault.
-	Delegate Key Vault instantiation and privileged access and use Azure Policy to enforce a consistent compliant configuration.
-	Default to Microsoft-managed keys for principal encryption functionality and use customer-managed keys when required.
-	Don't use centralized instances of Key Vault for application keys or secrets.
-	Don't share Key Vault instances between applications to avoid secret sharing across environments.


