module Webmotors
  class MarcasService
    cattr_accessor :base_uri
    cattr_accessor :model

    self.base_uri = "http://www.webmotors.com.br/carro/marcas"
    self.model = Make

    def fetch
      response = Net::HTTP.post_form(URI(self.base_uri), {})
      JSON.parse response.body
    end

    def sync!
      ActiveRecord::Base.transaction do
        fetch.each { |item| create item }
      end
    end

    private

    def create(item)
      self.model.create! name: item["Nome"], webmotors_id: item["Id"]
    rescue ActiveRecord::RecordNotUnique
      Rails.logger.debug "Record already registered: #{item.inspect}"
    rescue Exception => e
      Rails.logger.debug "Resource invalid to import: #{item.inspect}. Reason: #{e.message}"
    end
  end
end