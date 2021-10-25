Terraforming 🌱 Heroku app
===========================

[Terraform](https://www.terraform.io/) [1.0](https://www.hashicorp.com/blog/announcing-terraform-0-12) as a [Heroku](https://www.heroku.com/) app.

Run Terraform CLI in the cloud:

```bash
heroku run terraform apply
```

🔬🚧 This is a community proof-of-concept, [MIT license](LICENSE), provided "as is", without warranty of any kind.

⭐️💁‍♀️ Uses the [Terraform Postgres backend](https://www.terraform.io/docs/backends/types/pg.html).

Set-up
------

### Create Heroku Team

Terraform works best with Heroku when contained by a team.

▶️ [Create a team](https://dashboard.heroku.com/teams/new) or use an existing team.

### Create Heroku Account for Terraform

Terraform uses an authorization token (secret key) access the Heroku API.

Terraform's access can be isolated from your main user account by creating a separate Heroku account & authorization token, and inviting the new account to the team.

▶️ [Sign-up for another account](https://signup.heroku.com/). Set the first & last name to "Terraform" & "app"

▶️ [Create an Authorization for Terraform](https://dashboard.heroku.com/account/applications#authorizations). Set its description to `terraforming-app`. Note the generated **Authorization token**.

▶️ [Invite the new account to the team](https://devcenter.heroku.com/articles/heroku-teams#setting-up-your-heroku-team). Set its role to **admin**, so that it can fully manage apps and other resources.

### Deploy Terraform for Team

Create a new app for Terraform by clicking the "Deploy" button below. On the form that appears, set:

* **App name** to something like `teamname-terraform`
* **App owner** to the team name created above
* **HEROKU_API_KEY** to the **Authorization token** generated above
* **HEROKU_EMAIL** to the email of the separate account created above

[![Deploy to Heroku](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)

### Connect source code

Create a local working copy of the Heroku app, to begin committing & applying Terraform configurations.

✏️ *Replace `$APP_NAME` with the value of the **App name** created above, like `teamname-terraform`*

```bash
git clone https://github.com/mars/terraforming-app.git $APP_NAME
cd $APP_NAME
heroku git:remote --app $APP_NAME
```

Usage
-----

Once [set-up](#user-content-set-up) is complete, you can begin using Terraform!

### Create your Terraform config

Use the [Heroku provider](https://www.terraform.io/docs/providers/heroku/) and [others](https://www.terraform.io/docs/providers/) to build-up configuration in `*.tf` files.

### Push your changes

✏️ *Replace `$APP_NAME` in the following commands with your own unique app name.*

```bash
git add .
git commit -m 'Initial configuration'

# The included `main.tf` example requires the `example_app_name` variable
heroku config:set TF_VAR_example_app_name=$APP_NAME

git push heroku master
```

⏳ Wait for the push to complete.

### Run Terraform

Use interactively in one-off dynos:

```bash
heroku run terraform plan
heroku run terraform apply
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

🚦 Terraform waits here, to verify the actions it will take. **Type `yes` to proceed.**

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

⏳ Once the run completes, you can fetch outputs from the configuration, like the app URL from the included example:

```bash
heroku run terraform output example_app_url
```

With the included example, you may easily view the app's build log using curl:

```bash
curl "$(heroku run terraform output example_app_build_log_url)"
```

Dev Notes 📓
------------

### Manual setup

```bash
export APP_NAME=my-app
git clone https://github.com/mars/terraforming-app
cd terraforming-app/

heroku create $APP_NAME --buildpack mars/terraforming
heroku addons:create heroku-postgresql

# Use Terraform 0.12 to support Postgres backend
heroku config:set TERRAFORM_BIN_URL=https://releases.hashicorp.com/terraform/0.12.0/terraform_0.12.0_linux_amd64.zip

# Set credentials for the Terraform Heroku provider
heroku config:set HEROKU_API_KEY=xxxxx HEROKU_EMAIL=x@example.com

# Set Terraform input variables
heroku config:set TF_VAR_example_app_name=$APP_NAME-example

git push heroku master
```

### Run Terraform locally w/ Heroku Postgres backend

```bash
# First-time for each terminal
export DATABASE_URL=`heroku config:get DATABASE_URL`

# First-time for each project
terraform init -backend-config="conn_str=$DATABASE_URL"

# Then, apply & destroy as you like.
terraform apply
terraform destroy
```

### Run Terraform locally w/ local Postgres backend

```bash
# Create the local database using Postgres Client tool
createdb terraform_backend

# First-time for each terminal
export DATABASE_URL='postgres://localhost/terraform_backend?sslmode=disable'

# First-time for each project
terraform init -backend-config="conn_str=$DATABASE_URL"

# Then, apply & destroy as you like.
terraform apply
terraform destroy
```
