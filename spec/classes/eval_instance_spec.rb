require "rails_helper"

RSpec.describe Nstance::Rails::EvalInstance do
  let(:token) do
    Nstance::Rails::Token.new(
      cmd: "node script.js",
      image: "node",
      success_regexp: nil,
      stdin: false
    )
  end

  subject { Nstance::Rails::EvalInstance.new(token) }

  describe "#run" do
    describe "when given a hash of files" do
      let(:files) { { "script.js" => "console.log('hello world');" } }

      it "executes the run command on the instance of Nstance with the correct args" do
        expect(subject.nstance).to receive(:run).with(token.cmd, user: "root", timeout: subject.timeout, files: files)
        subject.run(files: files)
      end
    end
  end

  describe "#stop" do
    it "calls stop on the instance of Nstance::Instance" do
      expect(subject.nstance).to receive(:stop)
      subject.stop
    end
  end

  describe "#timeout" do
    it "defaults to 30 seconds" do
      expect(subject.timeout).to eq 30.seconds
    end

    describe "when token.stdin? is true" do
      let(:token) do
        Nstance::Rails::Token.new(
          cmd: "node script.js",
          image: "node",
          success_regexp: nil,
          stdin: true
        )
      end

      it "is set to 1 minute" do
        subject = Nstance::Rails::EvalInstance.new(token)
        expect(subject.timeout).to eq 1.minute
      end
    end
  end

  describe "#nstance" do
    let(:nstance) { instance_double Nstance::Instance }

    it "initializes Nstance with the instance's docker image and driver" do
      expect(Nstance).to receive(:create).with(image: subject.docker_image, driver: subject.driver) { nstance }
      subject.nstance
    end

    it "caches the created Nstace" do
      expect(Nstance).to receive(:create).exactly(:once) { nstance }
      subject.nstance
      subject.nstance
    end

    it "uses the attach driver by default" do
      driver = :docker_attach
      expect(Nstance).to receive(:create).with(hash_including(driver: driver))
      subject.nstance
    end

    it "uses the exec driver when token.stdin? is true" do
      allow(token).to receive(:stdin?) { true }

      driver = :docker_exec
      expect(Nstance).to receive(:create).with(hash_including(driver: driver))
      subject.nstance
    end

    it "uses the latest version of the image by default" do
      image = "#{token.image}:latest"
      expect(Nstance).to receive(:create).with(hash_including(image: image))
      subject.nstance
    end

    it "uses the specified version of the image if provided" do
      image = "node:2.6.3"
      allow(token).to receive(:image) { image }
      expect(Nstance).to receive(:create).with(hash_including(image: image))
      subject.nstance
    end
  end
end
