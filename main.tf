terraform {
  required_providers {
    heroku = {
      source = "heroku/heroku"
      version = "4.6.0"
    }
  }
}

variable "example_app_name" {
  description = "Name of the Heroku app provisioned as an example"
}

resource "heroku_app" "example" {
  name   = var.example_app_name
  region = "us"
}

resource "heroku_build" "example" {
  app = heroku_app.example.name

  source {
    path = "app/"
  }
}

resource "heroku_formation" "example" {
  app        = heroku_app.example.name
  type       = "web"
  quantity   = 1
  size       = "Standard-1x"
  depends_on = [heroku_build.example]
}

output "example_app_url" {
  value = "https://${heroku_app.example.name}.herokuapp.com"
}

output "example_app_build_log_url" {
  value = heroku_build.example.output_stream_url
}

