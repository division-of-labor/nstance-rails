class Nstance::Rails::RunnableCodeEvalInstance
  class UnsupportedLanguageError < ArgumentError; end
  class NoPublicClassForJava < ArgumentError; end

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

  attr_reader :token, :cmd

  def initialize(token)
    @token = token

    lang = token.lang

    @config = LANGUAGE_CONFIGS[LANGUAGE_ALIASES[lang] || lang]
    @config || raise(UnsupportedLanguageError, lang)
  end

  def run(code = "")
    filename = filename_for_code(code)
    cmd      = command_for_filename(filename)

    nstance.run(cmd, files: { filename => code }, user: user, timeout: timeout) do |runner|
      yield runner
    end
  end

  def stop
    @nstance&.stop
  end

  def nstance
    @nstance ||= Nstance.create(image: docker_image, driver: driver)
  end

  def docker_image
    token.image || @config[:image]
  end

  def user
    "root"
  end

  def driver
    if token.stdin?
      :docker_exec
    else
      :docker_attach
    end
  end

  def timeout
    token.stdin? ? 1.minute : 10
  end

  def command_for_filename(filename)
    if token.lang == "java"
      "javac #{filename} && java #{filename.sub('.java','')}"
    else
      "#{@config[:cmd]} #{filename}"
    end
  end

  def filename_for_code(code = nil)
    case token.lang
    when "swift"
      "code.swift"
    when "java"
      public_class = code[/public class ([A-Za-z_$]+[a-zA-Z0-9_$]*)/, 1]
      raise NoPublicClassForJava unless public_class.present?
      "#{public_class}.java"
    else
      "code"
    end
  end
end
