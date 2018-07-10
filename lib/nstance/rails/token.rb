require "jwt"

module Nstance
  module Rails
    class Token
      SECRET = ENV["EVAL_TOKEN_SECRET"]

      attr_reader :cmd, :image, :success_regexp, :stdin

      def self.decode(token)
        payload = JWT.decode(token, SECRET)[0]
        new(**payload.slice(*%w(cmd image success_regexp stdin)).symbolize_keys)
      end

      def initialize(cmd:, image:, success_regexp: nil, stdin: false)
        @cmd            = cmd
        @image          = image
        @success_regexp = success_regexp
        @stdin          = stdin
      end

      def to_h
        {
          cmd:            cmd,
          image:          image,
          success_regexp: success_regexp,
          stdin:          stdin
        }
      end

      def to_s
        encode
      end

      def stdin?
        stdin
      end

      def encode
        JWT.encode(to_h, SECRET)
      end
    end
  end
end
