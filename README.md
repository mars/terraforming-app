Terraforming 🌱 Heroku app
===========================

[Terraform](https://www.terraform.io/) as a [Heroku](https://www.heroku.com/) app.

Run Terraform CLI in the cloud:

```bash
heroku run terraform apply
```

[![Deploy to Heroku](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)

🔬🚧 This is a community proof-of-concept, [MIT license](LICENSE), provided "as is", without warranty of any kind.

🌲🔥 To enable the [Postgres backend](https://github.com/mars/terraform/blob/v0.11.9-pg.02/website/docs/backends/types/pg.html.md) for Terraform, this app uses the `terraform` binary built from an unmerged pull request to Terraform (see: [hashicorp/terraform #19070](https://github.com/hashicorp/terraform/pull/19070)).

🌲🔥🔥 To enable the [Build resource](https://github.com/mars/terraform-provider-heroku/blob/v1.6.0-build_resource.01/website/docs/r/build.html.markdown) for Terraform Heroku provider, this app uses the `terraform-provider-heroku` plugin binary built from an unmerged pull request to the provider (see: [terraform-providers/terraform-provider-heroku #149](https://github.com/terraform-providers/terraform-provider-heroku/pull/149)).

Manual setup
------------

```bash
export APP_NAME=my-app
git clone https://github.com/mars/terraforming-app
cd terraforming-app/

heroku create $APP_NAME --buildpack mars/terraforming
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

```
$ heroku run terraform apply
Running terraform apply on ⬢ terraforming... up, run.3842 (Free)

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

  Enter a value: 
```

Terraform waits here, to verify the actions Terraform will take. Type `yes` to proceed.

```
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

Once the run completes, you can fetch outputs from the configuration, like the app URL from the included example:

```bash
heroku run terraform show example_app_url
```

With the included example, you may easily view the app's build log using curl:

```bash
curl "$(heroku run terraform output example_app_build_log_url)"
```
