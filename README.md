Rails app generated with [lewagon/rails-templates](https://github.com/lewagon/rails-templates), created by the [Le Wagon coding bootcamp](https://www.lewagon.com) team.
# Ceziam How its Written
# Table of contents

1. [Overview](#overview)
    1. [Skeleton](#skeleton)
2. [Frontend](#frontend)
    1. [Views](#views)
3. [Routes](#routes)

## Overview
### Skeleton <a name="skeleton"></a>
```bash
rails new \
--database postgresql \
--webpack \
-m https://raw.githubusercontent.com/lewagon/rails-templates/master/devise.rb \
ceziam
```

## Frontend <a name="frontend"></a>
### Views <a name="views"></a>
`application.html.erb` uses the `stylesheet_link_tag` below.
```ruby
    <%= stylesheet_link_tag 'application', media: 'all', 'data-turbolinks-track': 'reload' %>
```



