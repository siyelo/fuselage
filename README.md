## Welcome to Fuselage

Fuselage is an opinionated base application for Ruby on Rails 2.3.x.

We chose the gems and configurations that we like (and that the community is using), but you can easily fork our project and customize it to suit your needs.

Get your next Rails project off to a flying start with Fuselage.

## Features in a Nutshell

  * Haml, Sass, Compass, 960, jQuery
  * dry_scaffold with formtastic, factory-girl, RSpec
  * cucumber, rspec, autotest
  * Devise, paperclip, will_paginate, inherited_resources

## Quickstart

  * Replace/edit config/database.yml if you want to change it from the default SQLite3 (see the config/ directory for templates).

  * Install gems, create your database and setup the prepared defaults.

      $ rake setup

  * Start your server

      $ script/server

  * Visit your app @ http://localhost:3000

## More configuration goodies

  * Configure your dry_scaffold defaults in config/scaffold.yml

  * If you're a Heroku junkie like us

      $ heroku create
      $ git push heroku master

## Handy Commands

### DRY Scaffold

  Tons of useful scaffolding shortcuts here: http://github.com/grimen/dry_scaffold

### Formtastic

To generate some semantic form markup for your existing models, just run:

    ./script/generate form MODEL_NAME

## More Info

  * Github: http://github.com/siyelo/fuselage
  * Issues: http://github.com/siyelo/fuselage/issues
  * Feedback: http://getsatisfaction.com/siyelo/products/siyelo_fuselage
  * Blog: http://blog.siyelo.com

## How to Contribute

  See the TODO

## License

Licensed under the terms of the MIT License, please see MIT-LICENSE file for details.
