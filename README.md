# ActiveVersioning Workflow

ActiveVersioning Workflow is an extension of ActiveVersioning that provides version workflow for ActiveAdmin-based CMSes.

## Installation

ActiveVersioning Workflow is designed for ActiveAdmin, ActiveMaterial, and Rails 4.2+ applications, so ensure you have the following in your gemfile:
```ruby
gem 'activeadmin', github: 'activeadmin'
gem 'devise' # Necessary if using standard ActiveAdmin configuration                           
gem 'active_material', git: 'git@github.com:vigetlabs/active_material.git'
```
These should all be installed and configured as well.

Add this line to your application's Gemfile:
```ruby
gem 'active_versioning_workflow'
```

And then execute:
```
$ bundle install
$ rails generate active_versioning:workflow
$ bundle exec rake db:migrate
```

## Usage

### Configure Models for Versioning
First off, if you haven't already configured the models you'd like to have versioned, follow the steps in the [ActiveVersioning README](https://github.com/vigetlabs/active_versioning).

### Require Stylesheets and Javascript
We'll need to pull in some CSS and JS for versioning to look and function correctly in ActiveAdmin.

In `app/assets/javascripts/active_admin.js.coffee`, add:
```coffeescript
#= require active_versioning
```

In `app/assets/stylesheets/active_admin.scss`, add the following after the other ActiveAdmin-related import statements:
```scss
@import "active_versioning";
```

### Configuring ActiveAdmin Resources for Versioning Workflow
Now that all the setup is out of the way, there are three main things necessary to get versioning workflow for an ActiveAdmin resource:

1. Add versioned routes to the routes file
2. Include the workflow controller module to the ActiveAdmin resource
3. Configure how versioned resources are displayed in ActiveAdmin

#### Versioned Routes (using `ActiveVersioning::Workflow::Router`)
The generator for ActiveVersioning Workflow includes a router module that provides a `versioned_routes` method inside the main Rails routes block.  It takes a list of underscored model names and generates version routes for each of the given models:
```ruby
Rails.application.routes.draw do
  self.class.send(:include, ActiveVersioning::Workflow::Router) # Inserted after running the generator
  devise_for :admin_users, ActiveAdmin::Devise.config           # Inserted by an ActiveAdmin install
  ActiveAdmin.routes(self)                                      # Inserted by an ActiveAdmin install

  namespace :admin do
    versioned_routes :posts
  end
end
```

In a fresh ActiveAdmin-based Rails app, this is what your routes file would look like in order to manage a versioned `Post` model in ActiveAdmin under the `:admin` namespace (default namespace for ActiveAdmin).  If you have ActiveAdmin configured differently and are using different namespaces, you'll want to use `versioned_routes` in the appropriate context.

In this example, we'd get routes like `/admin/posts/1/versions` and `/admin/posts/1/versions/1`.

#### Versioned Controller (using `ActiveVersioning::Workflow::Controller`)
Running with the example of a versioned `Post` model, we should have a file that registers the `Post` model with ActiveAdmin (generated with the `rails generate active_admin:resource Post` command and probably lives at `app/admin/post.rb`).  At the top of the register block, include the controller module:
```ruby
ActiveAdmin.register Post do
  include ActiveVersioning::Workflow::Controller
end
```

This adds the necessary actions to the admin controller for our resource so we can work with versions.

#### Versioned Show Page
Finally, we'll want to configure the show page for our versioned resource.  This is done in a similar style to the regular `show` block in ActiveAdmin, except that we'll use `show_version` and `version_attributes_panel`:
```ruby
ActiveAdmin.register Post do
  include ActiveVersioning::Workflow::Controller

  permit_params :title, :body

  show_version do |version|
    version_attributes_panel(version) do
      attributes_table_for(version) do
        row :title
        row :body
      end
    end
  end
end
```
When all is said and done, this will give us an awesome interface for version workflow in ActiveAdmin:
![example](https://s3.amazonaws.com/f.cl.ly/items/2i2h1T1J0v2h0C2n0v3N/Screen%20Shot%202015-09-23%20at%203.15.32%20PM.png)
