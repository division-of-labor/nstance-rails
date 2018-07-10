require "nstance/rails/engine"
require "nstance/rails/config"
require "nstance/rails/token"
require "nstance/rails/eval_instance"

module Nstance
  module Rails
    def self.image_for_lang(lang)
      config = Nstance::Rails::Config.config_for_lang(lang)
      config[:image]
    end

    def self.token(cmd:, image:, success_regexp: nil, stdin: false)
      token = Nstance::Rails::Token.new(
        cmd:            cmd,
        image:          image,
        success_regexp: success_regexp,
        stdin:          stdin
      ).encode

      token
    end
  end
end
