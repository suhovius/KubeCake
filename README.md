# KubeCake

<p align="center">
  <img src=".data/kubecake-logo-small.png" alt="Hackathon Team Logo"/>
</p>

#### Intro

KubeCake is a DevOps GitOps, Infrastucture code reveiw app made as a task at the DevOps Course Hackathon.

#### Main Feature

Integration with Github and reviewing pull requests with the help of configurable Ollama prompts

#### Features + Techincal Details

Also app provies example of admin panel access permissions by presenting the notion of the `organization_admin` role along with `super_admin` role. `AdminUser` entities can be managed by admins with super admin role.
Super admin also can see and manage all the organisations and their related entites data.
While organisation admins can only manage organsations data to which they are granted access to.

Also admin panel allows `super_admin` users to see the rSwag API documentation and to monitor the state of the sidekiq bacground jobs and scheduled jobs at the 'Settings' menu section. Super admin users also can be managed there.

`Organisation` is presents business concept of some kind of corporate client of this admin panel.
Organisation has such related entites like: Github App configs, and authorized attached github repositories.

Pull requests must trigger the webhooks, which schedule background job that performs pull request code reivew with Ollama prompts and adds comments to the pull request.

### Purpose

Make MVP app for the DevOps Course hackathon, a configurable plantform to perform AI code reviews at Github with future expansion to different SCM platforms like Gitlab, Bitbucket, etc. It provides extendable architecture to support multiple AI sources in future.
Main purpose for MVP is to test the general implementation and basic functionality of the app.

# Deployment Settings

TBD:

I will have helm charts, terraform infrastructure code and github releases. Maybe it will have some github actions pipeline

### Ruby version

`ruby 3.3.1`

### System dependencies to start at local machine

`Docker (Docker Desktop)`, `ruby 3.3.1`

### Configuration at local machine with docker

- Run this command in the terminal `cp docker-compose.yml.example docker-compose.yml` to create docker compose file form the provided example

- Generate random key set with this `DATABASE_URL=dummy DATABASE_PORT=123 DATABASE_USER=dummy bin/rails db:encryption:init` in your termial. Pan no mind onto these weir dummy values they are just needed to load the enviromnent for this command, these values are not involved in the key set generation.
Command output will contain something like this:

```yaml
active_record_encryption:
  primary_key: <your generated primary_key value>
  deterministic_key: <your generated deterministic_key value>
  key_derivation_salt: <your generated key_derivation_salt value>
```

- Inside your local `docker-compose.yml` file at `rails` and `sidekiq` environment sections assign previously generated values at respective variables

```yaml
services:
  rails:
    # ...
    environment:
      # ...
      ACTIVE_RECORD_ENCRYPTION_PRIMARY_KEY: <your generated primary_key value>
      ACTIVE_RECORD_ENCRYPTION_DETERMINISTIC_KEY: <your generated deterministic_key value>
      ACTIVE_RECORD_ENCRYPTION_KEY_DERIVATION_SALT: <your generated key_derivation_salt value>
      # ...
  sidekiq:
    # ...
    environment:
      # ...
      ACTIVE_RECORD_ENCRYPTION_PRIMARY_KEY: <your generated primary_key value>
      ACTIVE_RECORD_ENCRYPTION_DETERMINISTIC_KEY: <your generated deterministic_key value>
      ACTIVE_RECORD_ENCRYPTION_KEY_DERIVATION_SALT: <your generated key_derivation_salt value>
      # ...
```

- Start project with `SUPER_ADMIN_PASSWORD=your_super_password docker-compose up` (Don't forget to provide your own secure password here instead of `your_super_password`. As it will be the password of the admin user with highest level of access permissions). By default super admin login email is `super.admin@kubecake.com`

- During starting process database also will be prepopulated with some dummy demo entities like Organisation and some dummy data

- After docker compose has finished starting up the application, open application domain `http://0.0.0.0:3000/` and enter the created above super admin credentials. It should log in you into the admin panel of the appication.

For local develpment purposes, in order to work with callbacks and redirects from Github, tunnel to local machine will be required [cloudflared](https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/do-more-with-tunnels/trycloudflare/) service is suggested to be used for that purpose.

Use this command to run tunner for local app, ajust port if your local rails app runs not on default rails port `3000`.

`cloudflared tunnel --url http://localhost:3000`

Also at `config/environments/development.rb` hosts must be configured if different service/domain is used

```
config.hosts = [
  /.*\.trycloudflare\.com/ # Allow requests from subdomains like `indexed-chart-oriented-italiano.trycloudflare.com`
]
```

### Github App configuration

### TODO: Add more details here

If you plan to setup yours Github App look [here](https://docs.github.com/en/apps/creating-github-apps/registering-a-github-app/registering-a-github-app)

`GITHUB_WEBHOOK_SECRET_TOKEN` must contain the same webhook secret as configured at app webhooks page

Configure app host, configure setup url (TBD), enable redirect on update, confugre webhooks and webhook secret

#### Github App Permissions

In `Repository permissions` select:
* `Contents` as `Read only`
* `Metadata` as `Read only`
* `Pull requests` as `Read and write`

In `Repository permissions` select:
* `Installation target`
* `Meta`
* `Pull request` (Will be processed only at this MVP Application version as for now)

At `Where can this GitHub App be installed?` select `Any account`

Generate Private Key and save pem file it later will be used for app tokens generation.

`App ID`, `Private Key`, and `Installation ID` will be used for Github API calls

### How to run tests

- Run specs with `bundle exec rspec` command

