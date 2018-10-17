Terraforming 🌱 Heroku app
===========================

[Terraform](https://www.terraform.io/) as a [Heroku](https://www.heroku.com/) app.

Run Terraform CLI in the cloud:

```bash
heroku run terraform apply
```

[![Deploy to Heroku](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)

🔬🚧 This is a community proof-of-concept, [MIT license](LICENSE), provided "as is", without warranty of any kind.

🌲🔥 To enable [Heroku Postgres](https://www.heroku.com/postgres) as the Terraform backend, this app uses the `terraform` binary built from an unmerged pull request to Terraform (see: [hashicorp/terraform #19070](https://github.com/hashicorp/terraform/pull/19070)).

Manual setup
------------

```bash
export APP_NAME=my-app
git clone https://github.com/mars/terraforming-app
cd terraforming-app/

heroku create $APP_NAME --buildpack https://github.com/mars/terraforming-buildpack
heroku addons:create heroku-postgresql

# Use our fork of Terraform that supports Postgres backend
# https://github.com/hashicorp/terraform/pull/19070
# 
heroku config:set TERRAFORM_BIN_URL=https://terraforming-buildpack.s3.amazonaws.com/terraform_0.11.9-pg.02_linux_amd64.zip

# Set credentials for the Terraform Heroku provider
heroku config:set HEROKU_API_KEY=xxxxx HEROKU_EMAIL=x@example.com

# Set Terraform input variables
heroku config:set TF_VAR_example_app_name=$APP_NAME-example

git push heroku master
```

Usage
-----

Deploy your Terraform HCL code to the app, and then run Terraform in one-off dynos:

```bash
heroku run terraform init
heroku run terraform apply
heroku run terraform output
```

Running apply, you'll see output like this:

```bash
$ heroku run terraform apply
Running terraform apply on ⬢ terraforming... up, run.3842 (Free)

Initializing the backend...

Successfully configured the backend "pg"! Terraform will automatically
use this backend unless the backend configuration changes.

Initializing provider plugins...
- Checking for available provider plugins on https://releases.hashicorp.com...
- Downloading plugin for provider "heroku" (1.5.0)...

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  + heroku_app.example
      id:                <computed>
      all_config_vars.%: <computed>
      config_vars.#:     <computed>
      git_url:           <computed>
      heroku_hostname:   <computed>
      internal_routing:  <computed>
      name:              "mars-terraforming-example"
      region:            "us"
      stack:             <computed>
      uuid:              <computed>
      web_url:           <computed>


Plan: 1 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

heroku_app.example: Creating...
  all_config_vars.%: "" => "<computed>"
  config_vars.#:     "" => "<computed>"
  git_url:           "" => "<computed>"
  heroku_hostname:   "" => "<computed>"
  internal_routing:  "" => "<computed>"
  name:              "" => "mars-terraforming-example"
  region:            "" => "us"
  stack:             "" => "<computed>"
  uuid:              "" => "<computed>"
  web_url:           "" => "<computed>"
heroku_app.example: Creation complete after 1s (ID: mars-terraforming-example)

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
```
