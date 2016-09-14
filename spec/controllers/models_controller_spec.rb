require 'rails_helper'

RSpec.describe ModelsController, type: :controller do
  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end

    it "must call WebMotors Api" do
      http = class_double("Net::HTTP").as_stubbed_const

      uri = URI("http://www.webmotors.com.br/carro/modelos")
      mock_response = double(:http, body: "[]")
      expect(http).to receive(:post_form).with(uri, marca: nil) { mock_response }

      get :index
    end

    it "must call WebMotors Api repassing argument" do
      http = class_double("Net::HTTP").as_stubbed_const

      uri = URI("http://www.webmotors.com.br/carro/modelos")
      mock_response = double(:http, body: "[]")
      expect(http).to receive(:post_form).with(uri, marca: "1") { mock_response }

      get :index, webmotors_make_id: "1"
    end

    it "must create Models based on Webmotors API response" do
      Make.delete_all
      Model.delete_all
      Make.create name: "Fiat", webmotors_id: 1

      http = class_double("Net::HTTP").as_stubbed_const
      uri = URI("http://www.webmotors.com.br/carro/modelos")
      mock_response = double(:http, body: '[{"Nome":"Uno"},{"Nome":"Palio"}]')
      expect(http).to receive(:post_form).with(uri, marca: "1") { mock_response }

      get :index, webmotors_make_id: "1"

      expect(Model.count).to eq 2
    end

    it "duplicated WebMotors response must be trated as uniq" do
      Make.delete_all
      Model.delete_all
      Make.create name: "Fiat", webmotors_id: 1

      10.times do
        http = class_double("Net::HTTP").as_stubbed_const
        uri = URI("http://www.webmotors.com.br/carro/modelos")
        mock_response = double(:http, body: '[{"Nome":"Uno"},{"Nome":"Palio"}]')
        expect(http).to receive(:post_form).with(uri, marca: "1") { mock_response }

        get :index, webmotors_make_id: "1"
      end

      expect(Model.count).to eq 2
    end

    it "must throw error when Make is not defined and WebMotors API respond with data" do
      Make.delete_all
      Model.delete_all

      http = class_double("Net::HTTP").as_stubbed_const
      uri = URI("http://www.webmotors.com.br/carro/modelos")
      mock_response = double(:http, body: '[{"Nome":"Uno"},{"Nome":"Palio"}]')
      expect(http).to receive(:post_form).with(uri, marca: "1") { mock_response }

      expect { get :index, webmotors_make_id: "1" }.to raise_error("undefined method `id' for nil:NilClass")
    end
  end
end
