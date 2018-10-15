terraform {
  backend "pg" {}
}

variable "example_app_name" {
  description = "Name of the Heroku app provisioned as an example"
}

provider "heroku" {
  version = "~> 1.5"
}

resource "heroku_app" "example" {
  name   = "${var.example_app_name}"
  region = "us"
}
