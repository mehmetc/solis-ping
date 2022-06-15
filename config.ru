$LOAD_PATH << '.'
require 'rack/cors'
require 'app/controllers/main_controller'
require 'lib/config_file'
require 'logger'

LOGGER = Logger.new(STDOUT)

use Rack::Cors do
  allow do
    origins '*'
    resource '*', methods: [:get], headers: :any
  end
end


map "#{ConfigFile[:services][:ping][:base_path]}" do
  LOGGER.info("Mounting 'MainController' on #{ConfigFile[:services][:ping][:base_path]}")
  run MainController
end
