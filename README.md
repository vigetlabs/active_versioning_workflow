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
gem 'active_versioning_workflow', git: 'git@github.com:vigetlabs/active_versioning_workflow.git'
```

And then execute:
```
$ bundle install
$ rails generate active_versioning:workflow
$ bundle exec rake db:migrate
```

## Usage

After installing all the necessary gems, there are a handful of things to do in order to get versioning workflow in place for an ActiveAdmin resource:

1. Configure models for versioning
2. Pull in necessary styles and javascript
3. Add versioned routes to the routes file
4. Include the workflow controller module to the ActiveAdmin resource
5. Configure how versioned resources are displayed in ActiveAdmin
6. Set up live preview (optional)

### Configure Models for Versioning
First off, if you haven't already configured the models you'd like to have versioned, follow the steps in the [ActiveVersioning README](https://github.com/vigetlabs/active_versioning).

### Require Stylesheets and Javascript
We'll need to pull in some CSS and JS for versioning to look and function correctly in ActiveAdmin.

In `app/assets/javascripts/active_admin.js.coffee`, add:
```coffeescript
#= require active_versioning/workflow
```

In `app/assets/stylesheets/active_admin.scss`, add the following after the other ActiveAdmin-related import statements:
```scss
@import "active_versioning/workflow";
```

### Versioned Routes (using `ActiveVersioning::Workflow::Router`)
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

### Versioned Controller (using `ActiveVersioning::Workflow::Controller`)
Running with the example of a versioned `Post` model, we should have a file that registers the `Post` model with ActiveAdmin (generated with the `rails generate active_admin:resource Post` command and probably lives at `app/admin/post.rb`).  At the top of the register block, include the controller module:
```ruby
ActiveAdmin.register Post do
  include ActiveVersioning::Workflow::Controller
end
```

This adds the necessary actions to the admin controller for our resource so we can work with versions.

### Versioned Show Page
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

### Live Preview
ActiveVersioning Workflow allows for some optional basic previewing functionality that leverages the non-admin controller for a resource.  If you'd like to take advantage of previewing, here's how you'll want to set it up:
```ruby
class PostsController < ApplicationController
  extend ActiveVersioning::Workflow::Previewable

  preview_resource :post

  def show
  end

  private

  def post
    @post ||= Post.find(params[:id])
  end
  helper_method :post
end
```

The `extend` adds the necessary functionality and `preview_resource` class method to the controller.  Previewing only works for show pages where there's a single resource to preview, so you'll need a `show` method (and the corresponding route in your routes file) and then point the `preview_resource` at the reader method for the versioned resource.

In the ActiveAdmin draft panel, you'll see an extra preview button:
![preview](https://s3.amazonaws.com/f.cl.ly/items/1a3E1I0N3G36211k3m3t/Screen%20Shot%202015-09-24%20at%209.15.47%20AM.png)

This will open a new window with our `PostsController#show` rendered out with the current draft version of our post.
