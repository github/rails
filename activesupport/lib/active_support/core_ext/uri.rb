# encoding: utf-8

if RUBY_VERSION >= '1.9'
  require 'uri'

  str = "\xE6\x97\xA5\xE6\x9C\xAC\xE8\xAA\x9E" # Ni-ho-nn-go in UTF-8, means Japanese.

  unless str == URI::DEFAULT_PARSER.unescape(URI::DEFAULT_PARSER.escape(str))
    URI::Parser.class_eval do
      remove_method :unescape
      def unescape(str, escaped = @regexp[:ESCAPED])
        enc = (str.encoding == Encoding::US_ASCII) ? Encoding::UTF_8 : str.encoding
        str.gsub(escaped) { [$&[1, 2].hex].pack('C') }.force_encoding(enc)
      end
    end
  end
end

module URI
  class << self
    def parser
      @parser ||= URI.const_defined?(:Parser) ? URI::Parser.new : URI
    end
  end
end
