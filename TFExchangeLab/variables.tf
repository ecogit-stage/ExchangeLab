variable "prefix" {
  description = "The Prefix used for all resources in this example"
  default     = "lab"
}

variable "location" {
  description = "The Azure Region in which the resources in this example should exist"
  default     = "eastus"
}

variable "number_of_disks" {
  description = "The number of Data Disks which should be attached to the Exchange Servers"
  default     = 4
}

variable "admin_username" {
  description = "The name of the administrator user"
  default     = "azureuser"
}

variable "admin_password" {
  description = "The password of the administrator user"
  default     = "NoDificil89!"
}

variable "vm_size" {
  description = "The password of the administrator user"
  default     = "Standard_D2S_v3"
  
}

