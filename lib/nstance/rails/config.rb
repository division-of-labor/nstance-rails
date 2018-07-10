module Nstance
  module Rails
    class Config
      LANGUAGE_CONFIGS = {
        "javascript" => { cmd: "node",          image: "node:6.2.0" },
        "ruby"       => { cmd: "ruby",          image: "ruby:2.4.0" },
        "python"     => { cmd: "python",        image: "python:3.5.1" },
        "swift"      => { cmd: "swift",         image: "swiftdocker/swift:snapshot-2016-09-02-a" },
        "java"       => { cmd: "",              image: "openjdk:8-jdk" },
        "csharp"     => { cmd: "/app/build.sh", image: "jwolgamott/tiy-dotnet-runnable:0.4-beta" }
      }

      LANGUAGE_ALIASES = {
        "js" => "javascript",
        "rb" => "ruby",
        "py" => "python",
        "sw" => "swift",
        "jv" => "java",
        "c#" => "csharp"
      }

      def self.config_for_lang(lang)
        LANGUAGE_CONFIGS[LANGUAGE_ALIASES[lang] || lang]
      end
    end
  end
end
