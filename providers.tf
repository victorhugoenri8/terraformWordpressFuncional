
# providers con tags que se ponen
# en todo
provider "aws" {
  region = "ca-central-1"
  default_tags {
    tags = var.tags
  }
}