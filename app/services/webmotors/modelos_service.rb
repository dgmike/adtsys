module Webmotors
  class ModelosService
    cattr_accessor :base_uri
    cattr_accessor :cache_key

    self.base_uri = "http://www.webmotors.com.br/carro/modelos"
    self.cache_key = "webmotors:modelos"

    def fetch(webmotors_id)
      raise ArgumentError, "invalid argument type" unless webmotors_id.to_s.match(/^\d+$/)

      JSON.parse cached_fetch(webmotors_id)
    end

    private

    def cached_fetch(webmotors_id)
      Rails.cache.fetch "#{self.cache_key}:#{webmotors_id}" do
        response = Net::HTTP.post_form URI(self.base_uri), { webmotors_id: webmotors_id }
        response.body
      end
    end
  end
end