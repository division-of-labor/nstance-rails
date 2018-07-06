require 'jwt'

module Nstance
  module Eval
    module Token
      class ExerciseToken
        SECRET = ENV["EVAL_TOKEN_SECRET"]

        attr_reader :cmd, :image, :user_id, :success_regexp

        def self.decode(token)
          payload = JWT.decode(token, SECRET)[0]
          new(**payload.slice(*%w(cmd image user_id success_regexp)).symbolize_keys)
        end

        def initialize(cmd:, image:, user_id: nil, success_regexp: nil)
          @cmd            = cmd
          @image          = image
          @user_id        = user_id
          @success_regexp = success_regexp
        end

        def to_h
          {
            cmd:            cmd,
            image:          image,
            user_id:        user_id,
            success_regexp: success_regexp
          }
        end

        def to_s
          encode
        end

        def encode
          JWT.encode(to_h, SECRET)
        end
      end
    end
  end
end
