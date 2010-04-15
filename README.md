## Welcome to Fuselage

Fuselage is an opinionated base application for Ruby on Rails 2.3.5.

We chose the gems and configurations that we like (and that the community is using), but you can easily fork our project and customize it to suit your needs.

Get your next Rails project off to a flying start with Fuselage.

## Features in a Nutshell

  * Haml, Sass, Compass, 960, jQuery
  * dry_scaffold with formtastic, factory-girl, RSpec
  * cucumber, rspec, autotest
  * Devise, paperclip, will_paginate, inherited_resources

## Quickstart

  * Replace/edit config/database.yml if you want to change it from the default SQLite3 (see the config/ directory for templates).

  * Create your database and setup the prepared defaults.

      $ rake db:migrate

  * Start your server

      $ script/server

  * Login to your app @ http://localhost:3000 with user/password: admin/CHANGEME

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

## Full list of what you get

This is what you get out of the box, but its all easily replaced/extended;

    Rails (2.3.5)
    ORM
      ActiveRecord``
    Authentication
      Devise
    Controllers
      make_resourceful
      will_paginate
    DB + Models
      ActiveRecord
      paperclip
    Design/Layout
      jQuery
      haml
      sass
      compass + 960
      formtastic
    Development/Metrics
      rails-footnotes
      (metric_Fu tbd)
    Production
      exception_notification
      hoptoad
    Search
      N/A
    Security
      N/A
    Testing
      cucumber
      rspec
      autotest
      factory-girl

## More Info

  * Github: http://github.com/siyelo/fuselage
  * Issues: http://github.com/siyelo/fuselage/issues
  * Feedback: http://getsatisfaction.com/siyelo/products/siyelo_fuselage
  * Blog: http://blog.siyelo.com

## How to Contribute

  See the TODO

## License

Licensed under the terms of the MIT License, please see MIT-LICENSE file for details.
