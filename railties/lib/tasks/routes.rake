desc 'Print out all defined routes in match order, with names. Target specific controller with CONTROLLER=x.'
task :routes => :environment do
  all_routes = ActionController::Routing::Routes.routes
  require 'action_controller/routing/inspector'
  inspector = ActionController::Routing::RoutesInspector.new(all_routes)
  puts inspector.format(ActionController::Routing::ConsoleFormatter.new, ENV['CONTROLLER'])
end
