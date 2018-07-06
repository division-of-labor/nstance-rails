require 'jwt'

module Nstance
  module Rails
    module Token
      class EvalToken
        SECRET = ENV["EVAL_TOKEN_SECRET"]
        CRYPT  = ActiveSupport::MessageEncryptor.new(SECRET)

        attr_reader :lang, :image, :stdin, :source_gid

        def self.decode(token)
          payload = JWT.decode(token, SECRET)[0]
          payload["image"] = decrypt(payload["image"])
          new(**payload.slice("lang", "image", "stdin", "source_gid").symbolize_keys)
        end

        def initialize(lang:, image: nil, stdin: false, source_gid: nil)
          @lang       = lang
          @image      = image
          @stdin      = !!stdin
          @source_gid = source_gid
        end

        def to_s
          encode
        end

        def stdin?
          stdin
        end

        def to_h
          {
            lang:       lang,
            image:      encrypt(image),
            stdin:      stdin,
            source_gid: source_gid
          }
        end

        def encode
          JWT.encode(to_h, SECRET)
        end

      private

        def self.decrypt(encrypted_data)
          CRYPT.decrypt_and_verify(encrypted_data)
        end

        def encrypt(data)
          CRYPT.encrypt_and_sign(data)
        end
      end
    end
  end
end
