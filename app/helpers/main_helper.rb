require 'json'
require 'lib/config_file'

module Sinatra
  module MainHelper
    def endpoints
      settings.solis.list_shapes.map { |m| "/#{m.tableize}" }.sort
    end

    def api_error(status, source, title = "Unknown error", detail = "")
      content_type :json
      { "errors": [{
                     "status": status,
                     "source": { "pointer": source },
                     "title": title,
                     "detail": detail
                   }] }
    end

    def service_alive?(k)
      alive = {}
      result = HTTP.timeout(3).get("#{ConfigFile[:services][k][:host]}#{ConfigFile[:services][k][:base_path]}")
      api = result.body.to_s.length > 0 && (result.status < 400 || result.status > 499) ? true : false
      alive['api'] = api

      result = HTTP.post("#{ConfigFile[:services][k][:host]}/_sparql", form: { query: 'ask where{?s ?p ?o}' })
      storage = result.body.to_s =~ /TRUE \.$/ ? true : false
      alive['storage'] = storage if result.status == 200

      alive
    rescue HTTP::Error => e
      { 'api': false }
    end

  end
  helpers MainHelper
end