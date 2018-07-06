require "dotenv-rails"

module Nstance
  module Rails
    class Engine < ::Rails::Engine
      isolate_namespace Nstance::Rails

      Dotenv::Railtie.load
    end
  end
end
