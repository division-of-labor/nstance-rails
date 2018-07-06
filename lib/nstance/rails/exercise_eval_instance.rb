class Nstance::Rails::ExerciseEvalInstance
  attr_reader :token

  def initialize(token)
    @token = token
  end

  def run(files: {}, tarball: nil)
    if files
      nstance.run(token.cmd, user: user, timeout: timeout, files: files) do |runner|
        yield runner
      end
    else
      nstance.run(token.cmd, user: user, timeout: timeout, archives: tarball) do |runner|
        yield runner
      end
    end
  end

  def stop
    @nstance&.stop
  end

  def nstance
    @nstance ||= Nstance.create(image: docker_image)
  end

  def user
    "root"
  end

  def timeout
    30
  end

  def docker_image
    image = token.image
    image.include?(":") ? image : "#{image}:latest"
  end
end
