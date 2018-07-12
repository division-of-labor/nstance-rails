module Nstance::Rails
  class EvalChannel < ApplicationCable::Channel
    # Each eval view subscribes to this channel and sends a JWT token, which
    # contains the image and full command to use.
    def subscribed
      @token = Nstance::Rails::Token.decode(params[:token])
    end

    def eval(data)
      instance.run(files: data["files"]) do |runner|
        runner.on_chunk do |stream, chunk|
          transmit chunk: chunk.force_encoding("UTF-8")
        end

        runner.on_complete do |result|
          @runner = nil
          transmit_result(@token, result)
        end

        @runner = runner
      end
    end

    # Sends input to the current runner as STDIN.
    def receive_input(data)
      @runner << data["input"] if @runner
    end

  private

    def instance
      connection.cached_eval_instance(@token)
    end

    def transmit_result(token, result)
      success = !result.timeout? && !result.error &&
        attempt_success?(result.status, result.log, token.success_regexp)

      transmit result: {
        success:   success,
        exit_code: result.status,
        output:    result.log
      }
    end

    # Nstance fires async events from its own thread pool, so if we need to do DB
    # work, we need to do it on ActionCable's event loop where ActiveRecord's DB
    # connections are properly pooled.
    def on_event_loop(&block)
      connection.worker_pool.async_exec self, connection: connection, &block
    end

    def attempt_success?(exit_code, output, success_regexp = nil)
      if success_regexp.present?
        !!(output =~ Regexp.new(success_regexp))
      else
        exit_code&.to_i == 0
      end
    end
  end
end
