module Webmotors
  class MarcasService
    cattr_accessor :base_uri
    cattr_accessor :model
    cattr_accessor :cache_key

    self.base_uri = "http://www.webmotors.com.br/carro/marcas"
    self.model = Make
    self.cache_key = 'webmotors:marcas'

    def self.sync!
      unless Rails.cache.exist? self.cache_key
        self.new.sync!
      end
    end

    def fetch
      JSON.parse fetch_cached
    end

    def sync!
      ActiveRecord::Base.transaction do
        fetch.each { |item| create item }
      end
    end

    private

    def fetch_cached
      Rails.cache.fetch self.cache_key do
        response = Net::HTTP.post_form(URI(self.base_uri), {})
        response.body
      end
    end

    def create(item)
      self.model.create! name: item["Nome"], webmotors_id: item["Id"]
    rescue ActiveRecord::RecordNotUnique
      Rails.logger.debug "Record already registered: #{item.inspect}"
    rescue Exception => e
      Rails.logger.debug "Resource invalid to import: #{item.inspect}. Reason: #{e.message}"
    end
  end
end