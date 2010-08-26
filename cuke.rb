rvmrc = <<-RVMRC
rvm_gemset_create_on_use_flag=1
rvm gemset use ree@#{app_name}
RVMRC

create_file ".rvmrc", rvmrc

gitignore = <<-GITIGNORE
*~
.DS_Store
.bundle
capybara-*.html
config/database.yml
db/*.db
db/*.sql
log/*.log
rerun.txt
tmp/**/*
GITIGNORE

run 'rm .gitignore'
create_file ".gitignore", gitignore

gemfile = <<-GEMFILE

gem 'haml-rails', ">= 0.0.2"

# Console display helpers
gem 'awesome_print'
gem 'looksee'
gem 'wirble'

group :development do
  gem 'web-app-theme-rails'
end

group :test, :cucumber do
  gem 'capybara', '>= 0.3.8'
  gem 'cucumber-rails', '>= 0.3.2'
  gem 'database_cleaner', '>= 0.5.2'
  gem 'factory_girl_rails', '>= 1.0.0'
  gem 'launchy', '>= 0.3.5'
  gem 'rspec-rails', '>= 2.0.0.beta.12'
  gem 'spork', '>= 0.8.4'
end

group :test, :cucumber, :development do
  gem 'factory_girl_generator', '>= 0.0.1'
end

group :test, :cucumber, :development, :staging do
  # For debugging, use one of the following
  # gem 'ruby-debug'   # For Ruby 1.8
  # gem 'ruby-debug19' # For Ruby 1.9
end
GEMFILE

append_file 'Gemfile', gemfile

generators = <<-GENERATORS

    config.generators do |g|
      g.test_framework :rspec, :fixture => true, :views => false
      g.intergration_tool :rspec
      g.template_engine 'web_app_theme'
    end
GENERATORS

application generators

get "http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js",  "public/javascripts/jquery.js"
get "http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.1/jquery-ui.min.js", "public/javascripts/jquery-ui.js"
get "http://github.com/rails/jquery-ujs/raw/master/src/rails.js", "public/javascripts/rails.js"

gsub_file 'config/application.rb', 'config.action_view.javascript_expansions[:defaults] = %w()', 'config.action_view.javascript_expansions[:defaults] = %w(jquery.js jquery-ui.js rails.js)'

run "cp config/database.yml config/database.yml.example"

remove_file "app/views/layouts/application.html.erb"

create_file "log/.gitkeep"
create_file "tmp/.gitkeep"

git :init
git :add => '.'

docs = <<-DOCS

Note that the DEBUG gems have been commented out in the Gemfile
Uncomment the gem that corresponds to your Ruby version

Run the following commands to complete the setup of #{app_name.humanize}:

cd #{app_name}
gem install bundler --pre
bundle install
script/rails generate rspec:install
script/rails generate cucumber:install --rspec --capybara
script/rails generate web_app_theme:layout --app-name=#{app_name.humanize} --theme=bec

DOCS

log docs
