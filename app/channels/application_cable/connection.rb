module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :uuid

    def connect
      self.uuid = SecureRandom.uuid
      @mutex = Mutex.new
      @current_user = env["warden"].user
    end

    def current_user
      @current_user
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
          when Nstance::Rails::Token::ExerciseToken
            @eval_instance = Nstance::Rails::ExerciseEvalInstance.new(token)
          when Nstance::Rails::Token::EvalToken
            @eval_instance = Nstance::Rails::RunnableCodeEvalInstance.new(token)
          else
            raise ArgumentError
          end
        end

        @eval_instance
      end
    end
  end
end
