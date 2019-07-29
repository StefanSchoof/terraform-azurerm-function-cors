variable "allowed_origins" {
  type        = list(string)
  description = "list of origins that should be allowed to make cross-origin calls (for example: http://example.com:12345). To allow all, use \"*\" and remove all other origins from the list."
}

variable "resource_group_name" {
  type        = string
  description = "Name of resource group."
}

variable "function_app_name" {
  type        = string
  description = "Name of the function app."
}
