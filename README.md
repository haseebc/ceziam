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
5. [Models](#model)
    1. [checks table](#checks)
6. [Attack Engine](#attackengine)
    1. [Attack Calls](#attackcalls)
7. [Java Scripts Used](#js)
    1. [Timer check for script to run](#timerjs)

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
### Application.html.erb
This is a core file used to serve views.
Make sure that javascripts are in asset pipeline. This requires new file `/app/assets/javascripts/javascript.js
```javascript
//= require rails-ujs
//= require jquery
//= require bootstrap
//= require_tree .

$(document).ready(function(){
    $( "a.scroll" ).click(function( event ) {
        event.preventDefault();
        $("html, body").animate({ scrollTop: $($(this).attr("href")).offset().top }, 500);
    });
});
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
Then we define methods in the checks_controller.rb
```ruby
  def new
    @check = Check.new
  end

  def create
    hostname_verified = hostname_valid?(params[:hostname])
    if hostname_verified
      @check = Check.new(hostname: hostname_verified)
      @check.user = current_user if current_user
      if @check.save
        if current_user
          redirect_to check_full_report_path(@check)
        else
          session[:last_check_id] = @check.id
          redirect_to check_path(@check)
        end
      else
        flash[:alert] = 'An error occured.'
        redirect_to root_path
      end
    else
      # feeback about non valid hostname
      flash[:alert] = 'Please remove "http://" or enter a valid hostname to run the check.'
      render 'pages/home'
    end
  end

  def show
    @check = Check.find(params[:id])
  end

  def full_report
    @check = Check.find(params[:check_id])
    unless @check.user
      @check.user = current_user
      @check.save
    end
  end

  private

  def hostname_param
    params.require(:check).permit(:hostname)
  end

  def hostname_valid?(user_input)
    valid_hostname_regex = /^(?!:\/\/)([a-zA-Z0-9-_]+\.)*[a-zA-Z0-9][a-zA-Z0-9-_]+\.[a-zA-Z]{2,11}?$/
    user_input.tr!('/', '') if user_input.end_with? '/'
    user_input.match(valid_hostname_regex)
  end
```
We now get the error `uninitialized constant ChecksController::Check`as there is no class called Check. This needs to be done
- model check.rb with Check class 
- model vulnerability.rb with Vulnerability class 
- Services check_service.rb
- Workers hard.worker.rb

#### Resitrations Controller
`rails generate controller RegistrationsController`
```ruby
class RegistrationsController < Devise::RegistrationsController

    before_action :configure_permitted_parameters, if: :devise_controller?
  
    protected
  
    def configure_permitted_parameters
      # For additional fields in app/views/devise/registrations/new.html.erb
      devise_parameter_sanitizer.permit(:sign_up, keys: %i[firstname lastname company])
  
      # For additional in app/views/devise/registrations/edit.html.erb
      devise_parameter_sanitizer.permit(:account_update, keys: %i[firstname lastname company])
      end
  
    def after_sign_up_path_for(_resource)
      check_full_report_path(session[:last_check_id], anchor: 'report-banner-1') if session[:last_check_id]
    end
  
  end
  
```
#### Users Controller
`rails generate controller UsersController`
```ruby
class UsersController < ApplicationController

    def edit
      @user = current_user
    end
  
    def update
      @user = current_user
      if @user.update(user_params)
        redirect_to dashboard_profile_path
      else
        flash[:alert] = 'An error occured.'
        render :edit
      end
    end
  
    private
  
    def user_params
      params.require(:user).permit(:firstname, :lastname, :email, :company, :profilepicture)
    end
  
  end
```
#### Applications Controller
Edit the emply `application_controller.rb`file
```ruby
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  def configure_permitted_parameters
    # For additional fields in app/views/devise/registrations/new.html.erb
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[firstname lastname company])

    # For additional in app/views/devise/registrations/edit.html.erb
    devise_parameter_sanitizer.permit(:account_update, keys: %i[firstname lastname company])
  end

  def after_sign_in_path_for(resource)
    if session[:last_check_id]
      check = Check.find(session[:last_check_id])
      check.user = resource
      check.save
      dashboard_profile_path(resource)
    elsif session[:article_id]
      article_path(Article.find(session[:article_id]))
    else
      request.env['omniauth.origin'] || stored_location_for(resource) || root_path
    end
  end
end
```
#### Dashboard Controller
```bash
rails g controller DashboardController
```

```ruby
class DashboardController < ApplicationController

  def profile
    @checks = current_user.checks
  end

end
```


## Models <a name="model"></a>
We need to create the checks and vulnerabilities table. we can do this by creating a new model or standalone migration. 
Lets do **checks** table first.
### checks table  <a name="checks"></a>
```bash
rails generate model Check ip:string hostname:string scandur:string score:integer user_id:bigint fullresponse:jsonb attacksurface:jsonb domcheck_duration:integer duration:string 
```
This then does the following:
```ruby
      create    db/migrate/20200616101333_create_checks.rb
      create    app/models/check.rb
```
This is an empty model check.rb containing the class Check. And also an migration file for all the new `checks` table. 
```ruby
class CreateChecks < ActiveRecord::Migration[6.0]
  def change
    create_table :checks do |t|
      t.string :ip
      t.string :hostname
      t.string :scandur
      t.integer :score
      t.bigint :user_id
      t.jsonb :fullresponse
      t.jsonb :attacksurface
      t.integer :domcheck_duration
      t.string :duration

      t.timestamps
    end
  end
end
```

`rails db:migrate`
We then get the following table:
```ruby
  create_table "checks", force: :cascade do |t|
    t.string "ip"
    t.string "hostname"
    t.string "scandur"
    t.integer "score"
    t.bigint "user_id"
    t.jsonb "fullresponse"
    t.jsonb "attacksurface"
    t.integer "domcheck_duration"
    t.string "duration"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end
```
`rails g migration AddStateToChecks`then update the migration file manually
```ruby
 class AddStateToChecks < ActiveRecord::Migration[6.0]
  def change
    add_column :checks, :state, :string, default: "pending"
  end
end 
```
`rails db:migrate`
Now add the foeign key `rails g migration Checks`, edit the migration file adding the following:
`add_foreign_key :checks, :users`

## Create a New Table called vulnerabilities
```bash
rails generate model Vulnerabilitie port:string protocol:string state:string service:string check_id:bigint version:string reason:string product:string weakness:string risk:string recommandation:string impact:integer likelihood:integer netrisk:integer
```
Manually edit migration file and add:
```ruby
      t.index ["check_id"], name: "index_vulnerabilities_on_check_id"
```

Add the foreign key `rails g migration Vulnerabilities`
```ruby
class Vulnerabilities < ActiveRecord::Migration[6.0]
  def change
    add_foreign_key "vulnerabilities", "checks"
  end
end
```
Note **app/models/vulnerabilitie.rb** has been created and is not used for anything.

Note I had a to rename `vulnerabilitie.rb` to `vulnerability.rb`. What i should have done was rails generate model Vulnerability and all would have been correctly named etc. Lesson learned!




## Improvements
- structure landing page as a html doc.
- Note app/models/vulnerabilitie.rb has been created and is not used for anything. Can be deleted or infuture do a standalone migration instead. 

## Troubleshooting
### Heroku
```bash
heroku ps:exec
```

## Attack Engine <a name="attackengine"></a>
### Attack Calls <a name="attackcalls"></a>
Inputting attack domain results in action /checks#report-banner-1. Create action in checks controller invoked the Check class. The check class is in model check.rb. The Check class method then triggers HardWorker class which then starts the CheckService class run method.

    def run_async_check
        HardWorker.perform_async(id)
    end
CheckService class run method is the calling of the scripts to launch the attack.

## Java Scripts Used <a name="js"></a> 
### Timer check for script to run <a name="timerjs"></a> 
