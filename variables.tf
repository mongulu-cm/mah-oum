
# This is the region the service will be built in. Set this to a valid AWS
# region.
variable "region" {
  default = "eu-central-1"
}

# This is the prefix for the name of every created service. This can be anything
# you want, it is solely to prevent naming clashes if multiple AppSync services
# are published.
variable "prefix" {
  default = "mah-oum"
}
