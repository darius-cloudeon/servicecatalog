# Azure Key Vault compliance

[[_TOC_]]

---

## Cloud Security Framework (CSF) Policy

---

### Ensure that Azure Defender is set to On for Key Vault

|||
|--|--|
| Name | Azure Defender for Key Vault should be enabled |
| Version| `1.0.0` |
| Type | `BuiltIn` |

Turning on Azure Defender enables threat detection for Key Vault, providing threat
intelligence, anomaly detection, and behavior analytics in the Azure Security Center.

Enabling Azure Defender for Key Vault allows for greater defense-in-depth, with threat
detection provided by the Microsoft Security Response Center (MSRC).

Azure Defender for Key Vault provides an additional layer of protection and security intelligence by detecting unusual and potentially harmful attempts to access or exploit key vault accounts.

---

## Operational Policy

---

### Ensure that logging for Azure KeyVault is 'Enabled'

|||
|--|--|
| Name | Enable Detailed Logging |
| Version| `1.0.0` |
| Type | `BuiltIn` |

Enable AuditEvent logging for key vault instances to ensure interactions with key vaults are logged and available. Enable system logging to include detailed information such as an event source, date, user, timestamp, source addresses, destination addresses, and other useful elements.

Monitoring how and when key vaults are accessed, and by whom enables an audit trail of
interactions with confidential information, keys and certificates managed by Azure
Keyvault. Enabling logging for Key Vault saves information in an Azure storage account that
the user provides. This creates a new container named insights-logs-auditevent
automatically for the specified storage account, and this same storage account can be used
for collecting logs for multiple key vaults.

Audit enabling of diagnostic logs. This enables you to recreate activity trails to use for investigation purposes when a security incident occurs or when your network is compromised

|||
|--|--|
| Name | Diagnostic logs in Key Vault should be enabled |
| Version| `1.0.0` |
| Type | `BuiltIn` |

---

### Ensure the key vault is recoverable

|||
|--|--|
| Name | ### Ensure the key vault is recoverable |
| Version| `1.0.0` |
| Type | `BuiltIn` |

The key vault contains object keys, secrets and certificates. Accidental unavailability of a
key vault can cause immediate data loss or loss of security functions (authentication,
validation, verification, non-repudiation, etc.) supported by the key vault objects.
It is recommended the key vault be made recoverable by enabling the "Do Not Purge" and
"Soft Delete" functions. This is in order to prevent loss of encrypted data including storage
accounts, SQL databases, and/or dependent services provided by key vault objects (Keys,
Secrets, Certificates) etc., as may happen in the case of accidental deletion by a user or from
disruptive activity by a malicious user

There could be scenarios where users accidently run delete/purge commands on key vault
or attacker/malicious user does it deliberately to cause disruption. Deleting or purging a
key vault leads to immediate data loss as keys encrypting data and secrets/certificates
allowing access/services will become non-accessible. There are 2 key vault properties that
plays role in permanent unavailability of a key vault.

1. enableSoftDelete:

Setting this parameter to true for a key vault ensures that even if key vault is deleted, Key
vault itself or its objects remain recoverable for next 90days. In this span of 90 days either
key vault/objects can be recovered or purged (permanent deletion). If no action is taken,
after 90 days key vault and its objects will be purged.

1. enablePurgeProtection:

enableSoftDelete only ensures that key vault is not deleted permanently and will be
recoverable for 90 days from date of deletion. However, there are chances that the key
vault and/or its objects are accidentally purged and hence will not be recoverable. Setting
enablePurgeProtection to "true" ensures that the key vault and its objects cannot be
purged.
Enabling both the parameters on key vaults ensures that key vaults and their objects
cannot be deleted/purged permanently.

Malicious deletion of a key vault can lead to permanent data loss. A malicious insider in your organization can potentially delete and purge key vaults. Purge protection protects you from insider attacks by enforcing a mandatory retention period for soft deleted key vaults. No one inside your organization or Microsoft will be able to purge your key vaults during the soft delete retention period.
