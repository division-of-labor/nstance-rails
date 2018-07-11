module Nstance::Rails::ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :uuid

    def connect
      self.uuid = SecureRandom.uuid
      @mutex = Mutex.new
    end

    def disconnect
      @eval_instance&.stop
      @eval_instance = nil
    end

    def cached_eval_instance(token)
      @mutex.synchronize do
        if @eval_instance&.token != token

          # Stop the current instance before replacing it
          @eval_instance&.stop

          case token
          when Nstance::Rails::Token
            @eval_instance = Nstance::Rails::EvalInstance.new(token)
          else
            raise ArgumentError
          end
        end

        @eval_instance
      end
    end
  end
end
