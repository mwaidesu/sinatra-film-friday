require './config/environment'
run Sinatra::Application

#if ActiveRecord::Migrator.needs_migration?
if ActiveRecord::Base.connection.migration_context.needs_migration?

  raise 'Migrations are pending. Run `rake db:migrate` to resolve the issue.'
end

use Rack::MethodOverride
use MovieController
use UserController
use ReviewController
run ApplicationController
