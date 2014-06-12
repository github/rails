require 'uri'

module ActionController
  # Rewrites URLs for Base.redirect_to and Base.url_for in the controller.
  class UrlRewriter #:nodoc:
    RESERVED_OPTIONS = [:anchor, :params, :only_path, :host, :protocol, :port, :trailing_slash, :skip_relative_url_root]
    def initialize(request, parameters)
      @request, @parameters = request, parameters
    end

    def rewrite(options = {})
      if options.include?(:overwrite_params)
        ActiveSupport::Deprecation.warn 'The :overwrite_params option is deprecated. Specify all the necessary parameters instead', caller
      end
      rewrite_url(options)
    end

    def to_str
      "#{@request.protocol}, #{@request.host_with_port}, #{@request.path}, #{@parameters[:controller]}, #{@parameters[:action]}, #{@request.parameters.inspect}"
    end

    alias_method :to_s, :to_str

    private
      # Given a path and options, returns a rewritten URL string
      def rewrite_url(options)
        rewritten_url = ""

        unless options[:only_path]
          rewritten_url << (options[:protocol] || @request.protocol)
          rewritten_url << "://" unless rewritten_url.match("://")
          rewritten_url << rewrite_authentication(options)
          rewritten_url << (options[:host] || @request.host_with_port)
          rewritten_url << ":#{options.delete(:port)}" if options.key?(:port)
        end

        path = rewrite_path(options)
        rewritten_url << ActionController::Base.relative_url_root.to_s unless options[:skip_relative_url_root]
        rewritten_url << (options[:trailing_slash] ? path.sub(/\?|\z/) { "/" + $& } : path)
        rewritten_url << "##{CGI.escape(options[:anchor].to_param.to_s)}" if options[:anchor]

        rewritten_url
      end

      # Given a Hash of options, generates a route
      def rewrite_path(options)
        options = options.symbolize_keys
        options.update(options[:params].symbolize_keys) if options[:params]

        if overwrite = options.delete(:overwrite_params)
          options.update(@parameters.symbolize_keys)
          options.update(overwrite.symbolize_keys)
        end

        RESERVED_OPTIONS.each { |k| options.delete(k) }

        # Generates the query string, too
        Routing::Routes.url_for({:host => @request.host_with_port, :protocol => @request.protocol}.merge(options))
      end

      def rewrite_authentication(options)
        if options[:user] && options[:password]
          "#{CGI.escape(options.delete(:user))}:#{CGI.escape(options.delete(:password))}@"
        else
          ""
        end
      end
  end
end
