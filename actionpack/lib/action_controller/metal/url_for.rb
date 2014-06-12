require 'active_support/concern'

module ActionController
  module UrlFor
    extend ActiveSupport::Concern

    include ActionController::Routing::UrlFor

    def url_options
      super.reverse_merge(
        :host => request.host_with_port,
        :protocol => request.protocol,
        :_recall => request.symbolized_path_parameters
      ).merge(:script_name => request.script_name)
    end

    def _routes
      raise "In order to use #url_for, you must include routing helpers explicitly. " \
            "For instance, `include Rails.application.routes.url_helpers"
    end
  end
end
