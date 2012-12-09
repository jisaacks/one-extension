## One Extension

A small gem to enforce exclusion (or inclusion) of *.html* in your rails app routes. 

If SEO is of any importance to your application you probably don't want *path* and *path****.html*** returning the same content as Google will treat them as seperate pages.

Installing this gem will enforce only one route, and redirect all requests to the other

### Installation

 - Add `gem 'one-extension'` to your Gemfile
 - Run `bundle install`

### Usage

Add a call to `one_extension` in the controller you want to use it on. For example, if you want all requests to your Books controller with *.html* to be redirected you would add this to your books controller:

```ruby
class BooksController < ApplicationController
  one_extension :exclusion
```

Or if you want all requests in your application *without .html* to be redirected to include it, you would add this to your application controller:

```ruby
class ApplicationController < ActionController::Base
  one_extension :inclusion
```

#### Caveat
Keep in mind that this is not changing the urls generated by rails helpers like `url_for` so if you are enforcing the html on your entire application; to mimimize redirects you should add this to your *config/application.rb*:

```ruby
<NameOfYourApp>::Application.default_url_options = { format: "html" }
```