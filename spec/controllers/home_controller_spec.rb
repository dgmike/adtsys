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
  end
end
