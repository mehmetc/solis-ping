# frozen_string_literal: true
require 'http'
require_relative 'generic_controller'

class MainController < GenericController
  get '/' do
    content_type :json
    result = {}
    ConfigFile[:services].each_key do |k|
      next if k.eql?(:ping)
      result[k] = service_alive?(k)
    end

    status 500 if result.flatten.select{|s| s.is_a?(Hash)}.map{|m| m.values}.flatten.include?(false)

    result.to_json
  end
end
