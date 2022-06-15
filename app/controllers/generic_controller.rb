require 'sinatra/base'
require 'http/accept'

require 'app/helpers/main_helper'

class GenericController < Sinatra::Base
  helpers Sinatra::MainHelper

  configure do
    mime_type :jsonapi, 'application/vnd.api+json'
    set :method_override, true # make a PUT, DELETE possible with the _method parameter
    set :show_exceptions, false
    set :raise_errors, false
    set :root, File.absolute_path("#{File.dirname(__FILE__)}/../../")
    set :views, (proc { "#{root}/app/views" })
    set :logging, true
    set :static, true
    set :public_folder, "#{root}/public"
  end

  before do
    accept_header = request.env['HTTP_ACCEPT']
    accept_header = params['accept'] if params.include?('accept')
    accept_header = 'application/json' if accept_header.nil?

    media_types = HTTP::Accept::MediaTypes.parse(accept_header).map { |m| m.mime_type.eql?('*/*') ? 'application/json' : m.mime_type } || ['application/json']
    @media_type = media_types.first

    content_type @media_type
  end

  get '/' do
    halt '404', 'To be implemented'
  end

  not_found do
    content_type :json
    message = body
    logger.error(message)
    message.to_json
  end

  error do
    content_type :json
    message = { status: 500, body: "error:  #{env['sinatra.error'].to_s}" }
    logger.error(message)
    message.to_json
  end
end