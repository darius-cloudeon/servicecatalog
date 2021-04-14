variable clientprefix {
  description = "Client name used for resource naming"
  default     = "energinetdemocloudeon"
}

variable location {
  description = "Primary region for the services"
  default     = "West Europe"
}

variable environment {
  description = "Short name of environemt ex.: dev, prod, shared"
  default     = "dev"
}

locals {
  management-tags = {
    owner      = "owner@energinet.dk"
    costcenter = "001"
  }
}
variable subscription_id {
  description = "Subscription Id"
  default     = "null"
}