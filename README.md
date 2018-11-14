Terraforming 🌱 Heroku app
===========================

[Terraform](https://www.terraform.io/) as a [Heroku](https://www.heroku.com/) app.

Run Terraform CLI in the cloud:

```bash
heroku run terraform apply
```

🔬🚧 This is a community proof-of-concept, [MIT license](LICENSE), provided "as is", without warranty of any kind.

🌲🔥 To enable [Heroku Postgres](https://www.heroku.com/postgres) as the Terraform backend, this app uses the `terraform` binary built from an unmerged pull request [hashicorp/terraform #19070](https://github.com/hashicorp/terraform/pull/19070), [mars/terraform release v0.11.9-pg.02](https://github.com/mars/terraform/releases/tag/v0.11.9-pg.02).

Set-up
------

### Create Heroku Team

Terraform works best with Heroku when contained by a team.

▶️ [Create a team](https://dashboard.heroku.com/teams/new) or use an existing team.

### Create Heroku "Machine" Account

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

The included `main.tf` is required to deploy successfully. The buildpack will not work without `main.tf`. You can replace its content as needed.

### Push your changes

```bash
git add .
git commit -m 'Initial configuration'
git push heroku master
```

⏳ Wait for the push to complete.

### Run Terraform

Use interactively in one-off dynos:

```bash
heroku run terraform plan
heroku run terraform apply
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

### Run Terraform locally w/ Heroku Postgres backend

🌲🔥 Requires local `terraform` binary built from the Postgres backend PR ([hashicorp/terraform #19070](https://github.com/hashicorp/terraform/pull/19070)).

```bash
# First-time for each terminal
export DATABASE_URL=`heroku config:get DATABASE_URL`
$GOPATH/src/github.com/hashicorp/terraform/pkg/darwin_amd64/terraform init -backend-config="conn_str=$DATABASE_URL"

# Continue using Terraform with the Heroku app's Postgres backend
$GOPATH/src/github.com/hashicorp/terraform/pkg/darwin_amd64/terraform plan
$GOPATH/src/github.com/hashicorp/terraform/pkg/darwin_amd64/terraform apply
```
