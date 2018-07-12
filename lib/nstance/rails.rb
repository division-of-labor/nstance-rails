require "nstance/rails/engine"
require "nstance/rails/token"
require "nstance/rails/eval_instance"

module Nstance
  module Rails
    # Default used if constant not set in config/initializers/nstance_rails.rb
    LANGUAGE_CONFIGS = {
      "javascript" => { cmd: "node",          image: "node:6.2.0" },
      "ruby"       => { cmd: "ruby",          image: "ruby:2.4.0" },
      "python"     => { cmd: "python",        image: "python:3.5.1" },
      "swift"      => { cmd: "swift",         image: "swiftdocker/swift:snapshot-2016-09-02-a" },
      "java"       => { cmd: "",              image: "openjdk:8-jdk" },
      "csharp"     => { cmd: "/app/build.sh", image: "jwolgamott/tiy-dotnet-runnable:0.4-beta" }
    }

    def self.config_for_lang(lang)
      Nstance::Rails::LANGUAGE_CONFIGS[lang]
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
