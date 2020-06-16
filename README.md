Rails app generated with [lewagon/rails-templates](https://github.com/lewagon/rails-templates), created by the [Le Wagon coding bootcamp](https://www.lewagon.com) team.
# Ceziam, How It Was Written 
# Table of contents

1. [Overview](#overview)
    1. [Skeleton](#skeleton)
    2. [Gem files to add](#gems)
2. [Frontend](#frontend)
    1. [Views](#views)
3. [Routes](#routes)
4. [Controller](#controller)


## Overview
### Skeleton <a name="skeleton"></a>
```bash
rails new \
--database postgresql \
--webpack \
-m https://raw.githubusercontent.com/lewagon/rails-templates/master/devise.rb \
ceziam
```
- Versions: `Rails 6.0.3.1` `ruby 2.6.6p146`
- Install Node locally from here https://nodejs.org/en/download/
### Gems files to add <a name="gems"></a>
```ruby
gem 'bourbon'
gem 'crack'
gem 'jquery-rails'
gem 'json'
gem 'meta-tags', '~> 2.1'
gem 'net-scp'
gem 'net-ssh'
gem 'pygments.rb'
gem 'redcarpet'
gem 'sidekiq'
gem 'sidekiq-failures'
gem 'sitemap_generator'
```


## Frontend <a name="frontend"></a>
### Views <a name="views"></a>
`application.html.erb` uses the `stylesheet_link_tag` below.
```ruby
    <%= stylesheet_link_tag 'application', media: 'all', 'data-turbolinks-track': 'reload' %>
```
The `application.html.erb` we'll improve upon later.

Now get the basic view setup.
You can just copy the URL page as such below. The css won't work, we'll get that setup later.

```html
<!-- SEO Meta-tags -->
<% set_meta_tags title: 'Cyber-security checker',
                description: 'Detect your core cyber security risks including dangerous ports and attack surface with a simple website freely available to all.' %>
<div class="banner-green">
    <%= render 'shared/navbar' %>
    <div class="header-description">
        <h1><p class="header-title">Welcome to Ceziam</p></h1>
        <h2><p
        class="page-description">Detect your core cyber security risks with a simple website freely available to all.</p><h2>
    <form id="search" action="/checks#report-banner-1" method="post">
      <div>
       <%= hidden_field_tag :authenticity_token, form_authenticity_token %>
      <input class="string required" id="check-start" maxlength="255" name="hostname" size="50" type="text" placeholder="Insert your hostname e.g. cnn.com" autocomplete="off"/>
      </div>
      <div class="button-loader-container">
        <input class="button-white" id="button-banner" name="commit" type="submit" value="Detect" />
        <div class="container-animation">
        <div class="circles" id="loading-symbol" hidden>
          <div class="circle-multiple">
            <div class="circle"></div>
            <div class="circle"></div>
            <div class="circle"></div>
          <div class="start-screen">
            <div class="loading">
              <div class="loading__element el1">D</div>
              <div class="loading__element el2">E</div>
              <div class="loading__element el3">T</div>
              <div class="loading__element el4">E</div>
              <div class="loading__element el5">C</div>
              <div class="loading__element el6">T</div>
              <div class="loading__element el7">I</div>
              <div class="loading__element el8">N</div>
              <div class="loading__element el9">G</div>
              <div class="loading__element el13">.</div>
              <div class="loading__element el14">.</div>
              <div class="loading__element el15">.</div>
            </div>
          </div>
          <p class="disclamer">This could take up to 2 minutes...</p>
          </div>
        </div>
      </div>
      </div>
    </form>
    </div>
</div>
<script>
  const form = document.querySelector('#search');
  const gif = document.querySelector("#loading-symbol");
  form.addEventListener('submit', function(event) {
      gif.hidden = false;
  });
</script>
```
## Routes
### Routing <a name="routes"></a>
```ruby
  root to: 'pages#home'

  resources :checks do
    resources :vulnerabilities, only: %i[new create]
    get 'full-report'
  end
```
Here we have a root url going to `pages controller/home.html`
```ruby
verb "url", to: "controller#action"
```
## Controller
### Controller <a name="controller"></a>
`rails g controller Checks full_report`
```ruby
      create  app/controllers/checks_controller.rb
       route  get 'checks/full_report'
      invoke  erb
      create    app/views/checks
      create    app/views/checks/full_report.html.erb
      invoke  test_unit
      create    test/controllers/checks_controller_test.rb
```


## Improvements
- structure landing page as a html doc.
