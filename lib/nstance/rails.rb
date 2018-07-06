require "nstance/rails/engine"
require "nstance/rails/runnable_code_eval_instance"
require "nstance/rails/token/exercise_token"
require "nstance/rails/token/eval_token"

module Nstance
  module Rails
    def self.image_for_lang(lang)
      Nstance::Rails::RunnableCodeEvalInstance::LANGUAGE_CONFIGS[Nstance::Rails::RunnableCodeEvalInstance::LANGUAGE_ALIASES[lang] || lang]
    end

    def self.exercise_eval_token(exercise)
      token = Nstance::Rails::Token::ExerciseToken.new(
        cmd:            exercise.cmd,
        image:          exercise.docker_image,
        success_regexp: exercise.success_regexp,
        # user_id:        current_user.id
      ).encode

      token
    end

    def self.eval_token_for_code_fence(fence)
      token = Nstance::Rails::Token::EvalToken.new(
        lang:  fence.lang,
        image: fence.image,
        stdin: fence.stdin?
      ).encode

      token
    end
  end
end
