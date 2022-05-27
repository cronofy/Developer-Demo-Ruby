# Developer Demo Ruby

This repo is to be used alongside the Developer Demo Ruby Tutorial.

This repo contains two branches: `starter`, and `main`.

* The starter code you need to follow along with the tutorial is on the `starter` branch. Checkout this branch if you want to work through the tutorial step-by-step.
* The completed code for the tutorial is on the `main` branch. Checkout this branch if you want to view the full, finished code for the tutorial.

## Quickstart guide

  1. Clone this repository.
  1. `cd` into this repository's root directory.
  1. Run `rails credentials:edit` to open `config/credentials.yml.enc` and add the following:

```
cronofy:
  client_id: CLIENT_ID_GOES_HERE
  client_secret: CLIENT_SECRET_GOES_HERE
```

> If you are struggling to save the credentials within the credentials.yml.enc file you may need to run EDITOR="code --wait" rails credentials:edit. Replace code with your editor of choice, or leave the value as code for VSCode.

* Run `bundler install`: this will install the required dependencies.
* Run `rails db:migrate RAILS_ENV=development` to create the local db
* Run `rails s` to start the server.
* You can then view the running application at http://localhost:3000/.
