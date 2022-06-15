# frozen_string_literal: true
require 'http'
require_relative 'generic_controller'

class MainController < GenericController
  get '/' do
    content_type :json
    result = {
      "data": data_api?,
      "audit": audit_api?,
      "search": search_api?,
      "browse": browse_api?,
      "logic": logic_api?
    }

    status 500 if result.flatten.select{|s| s.is_a?(Hash)}.map{|m| m.values}.flatten.include?(false)

    result.to_json
  end
end
