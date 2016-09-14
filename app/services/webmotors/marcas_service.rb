module Webmotors
  class MarcasService
    cattr_accessor :base_uri
    self.base_uri = "http://www.webmotors.com.br/carro/marcas"

    def fetch
      response = Net::HTTP.post_form(URI(self.base_uri), {})
      JSON.parse response.body
    end
  end
end