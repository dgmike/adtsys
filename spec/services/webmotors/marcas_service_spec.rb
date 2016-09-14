require 'rails_helper'

RSpec.describe Webmotors::MarcasService, type: :model do
  it "must respond to :fetch" do
    expect(subject).to respond_to :fetch
  end

  it "must access WebMotors API" do
    http = class_double("Net::HTTP").as_stubbed_const

    uri = URI("http://www.webmotors.com.br/carro/marcas")
    mock_response = double(:http, body: "[]")
    expect(http).to receive(:post_form).with(uri, {}) { mock_response }

    subject.fetch
  end

  it "must parse result as JSON" do
    http = class_double("Net::HTTP").as_stubbed_const

    uri = URI("http://www.webmotors.com.br/carro/marcas")
    mock_response = double(:http, body: '[{"name":"Fiat"},{"name":"Ford"}]')
    expect(http).to receive(:post_form).with(uri, {}) { mock_response }

    expect(subject.fetch).to eq [{ "name" => "Fiat" }, { "name" => "Ford" }]
  end
end