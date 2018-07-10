module Nstance
  module Rails
    class EvalInstance
      attr_reader :token

      def initialize(token)
        @token = token
      end

      def run(cmd: nil, files: {}, tarball: nil)
        cmd ||= token.cmd

        if files
          nstance.run(cmd, user: user, timeout: timeout, files: files) do |runner|
            yield runner
          end
        else
          nstance.run(cmd, user: user, timeout: timeout, archives: tarball) do |runner|
            yield runner
          end
        end
      end

      def stop
        @nstance&.stop
      end

      def user
        "root"
      end

      def timeout
        token.stdin? ? 1.minute : 30
      end

      def docker_image
        image = token.image
        image.include?(":") ? image : "#{image}:latest"
      end

      def nstance
        @nstance ||= Nstance.create(image: docker_image, driver: driver)
      end

      def driver
        if token.stdin?
          :docker_exec
        else
          :docker_attach
        end
      end
    end
  end
end
