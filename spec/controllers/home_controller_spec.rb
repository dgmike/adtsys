require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end

    it "access API from motors" do
      http = class_double("Net::HTTP").as_stubbed_const

      uri = URI("http://www.webmotors.com.br/carro/marcas")
      mock_response = double(:http, body: "[]")
      expect(http).to receive(:post_form).with(uri, {}) { mock_response }

      get :index
    end

    it "creates Makes using http response" do
      Make.delete_all
      http = class_double("Net::HTTP").as_stubbed_const

      uri = URI("http://www.webmotors.com.br/carro/marcas")
      mock_response = double(:http, body: '[{"Nome":"Fiat","Id":1},{"Nome":"Audi","Id":2}]')
      expect(http).to receive(:post_form).with(uri, {}) { mock_response }

      get :index

      expect(Make.count).to eq 2
      expect(Make.select(:webmotors_id, :name).first.to_json).to eq '{"id":null,"name":"Fiat","webmotors_id":1}'
      expect(Make.select(:webmotors_id, :name).second.to_json).to eq '{"id":null,"name":"Audi","webmotors_id":2}'
    end

    it "avoid duplicated Makes" do
      Make.delete_all
      10.times do
        http = class_double("Net::HTTP").as_stubbed_const

        uri = URI("http://www.webmotors.com.br/carro/marcas")
        mock_response = double(:http, body: '[{"Nome":"Fiat","Id":1},{"Nome":"Audi","Id":2}]')
        expect(http).to receive(:post_form).with(uri, {}) { mock_response }

        get :index
      end

      expect(Make.count).to eq 2
    end
  end
end
