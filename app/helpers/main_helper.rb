require 'json'
require 'lib/config_file'

module Sinatra
  module MainHelper
    def endpoints
      settings.solis.list_shapes.map {|m| "/#{m.tableize}"}.sort
    end

    def api_error(status, source, title="Unknown error", detail="")
      content_type :json
      {"errors": [{
                    "status": status,
                    "source": {"pointer":  source},
                    "title": title,
                    "detail": detail
                  }]}
    end

    def data_api?
      result = HTTP.get("#{ConfigFile[:services][:data][:host]}/#{ConfigFile[:services][:data][:base_path]}")
      api = result.body.to_s.length > 0 ? true : false
      result = HTTP.post("#{ConfigFile[:services][:data][:host]}/_sparql", form: {query: 'ask where{?s ?p ?o}'})
      storage = result.body.to_s =~ /TRUE \.$/ ? true : false

      return {'api': api, 'storage': storage}#
    rescue HTTP::Error => e
      return {'api': false, 'storage': false}
    end

    def audit_api?
      result = HTTP.get("#{ConfigFile[:services][:audit][:host]}/#{ConfigFile[:services][:audit][:base_path]}/ping")
      return ::JSON.parse(result.body.to_s)
    rescue HTTP::Error => e
      return {'api': false, 'storage': false}
    end

    def search_api?
      result = HTTP.get("#{ConfigFile[:services][:search][:host]}/#{ConfigFile[:services][:search][:base_path]}/ping")
      return ::JSON.parse(result.body.to_s)
    rescue HTTP::Error => e
      return {'api': false, 'storage': false}
    end

    def browse_api?
      result = HTTP.get("#{ConfigFile[:services][:browse][:host]}/#{ConfigFile[:services][:browse][:base_path]}/ping")
      return ::JSON.parse(result.body.to_s)
    rescue HTTP::Error => e
      return {'api': false, 'storage': false}
    end

    def logic_api?
      result = HTTP.get("#{ConfigFile[:services][:logic][:host]}/#{ConfigFile[:services][:logic][:base_path]}/ping")
      return ::JSON.parse(result.body.to_s)
    rescue HTTP::Error => e
      return {'api': false, 'storage': false}
    end

  end
  helpers MainHelper
end