require 'rails_helper'

RSpec.describe Webmotors::ModelosService do
  describe "#fetch" do
    it "must respond to :fetch" do
      expect(subject).to respond_to :fetch
    end

    it "must cache response" do
      expect(Rails.cache).to receive(:fetch).with('webmotors:modelos:1') { '[]' }

      subject.fetch 1
    end

    it "must require one argument as numeral" do
      expect { subject.fetch }.to raise_error ArgumentError, "wrong number of arguments (given 0, expected 1)"

      expect { subject.fetch("invalid") }.to raise_error ArgumentError, "invalid argument type"
      expect { subject.fetch(:invalid) }.to raise_error ArgumentError, "invalid argument type"
      expect { subject.fetch([]) }.to raise_error ArgumentError, "invalid argument type"
      expect { subject.fetch({ type: :invalid }) }.to raise_error ArgumentError, "invalid argument type"
    end

    it "must post on Webmotors API" do
      http = class_double("Net::HTTP").as_stubbed_const

      mock_response = double(:http, body: '[]')
      expect(http).to receive(:post_form) { mock_response }

      subject.fetch "1"
    end

    it "must post on Webmotors API using argument" do
      http = class_double("Net::HTTP").as_stubbed_const

      uri = URI("http://www.webmotors.com.br/carro/modelos")
      mock_response = double(:http, body: '[]')
      expect(http).to receive(:post_form).with(uri, { webmotors_id: "1" }) { mock_response }

      expect(subject.fetch "1").to eq []
    end
  end

  describe "#sync!" do
    it "must respond to :sync!"
    it "must require one argument as numeral"
    it "must call :fetch with argument"
    it "must create Models based on :fetch response"
    it "must skip duplicated results"
    it "must log duplicated results"
    it "must log invalid results"
  end
end