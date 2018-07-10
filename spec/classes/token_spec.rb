require "rails_helper"

RSpec.describe Nstance::Rails::Token do
  let(:cmd) { "ruby foo.rb" }
  let(:image) { "ruby:2.4.0" }
  let(:secret) { ENV["EVAL_TOKEN_SECRET"] }

  describe "#encode" do
    subject { Nstance::Rails::Token.new(cmd: cmd, image: image, success_regexp: nil, stdin: false) }

    it "creates an encoded JWT" do
      expect(JWT).to receive(:encode).with(subject.to_h, secret) { "encoded_token" }

      expect(subject.encode).to eq "encoded_token"
    end
  end

  describe ".decode" do
    subject { Nstance::Rails::Token.new(cmd: cmd, image: image, success_regexp: nil, stdin: false).encode }

    it "decodes the JWT and instantiates the class with the payload" do
      expect(JWT).to receive(:decode).with(subject, secret)
        .and_return [{ "cmd" => cmd, "image" => image, "success_regexp" => nil, "stdin" => false }, {}]

      expect(Nstance::Rails::Token).to receive(:new)
        .with(cmd: cmd, image: image, success_regexp: nil, stdin: false)

      Nstance::Rails::Token.decode(subject)
    end
  end
end
