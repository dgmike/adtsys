module Webmotors
  class ModelosService
    cattr_accessor :base_uri
    cattr_accessor :cache_key

    self.base_uri = "http://www.webmotors.com.br/carro/modelos"
    self.cache_key = "webmotors:modelos"

    def self.sync!(webmotors_id)
      raise ArgumentError, "invalid argument type" unless webmotors_id.to_s.match(/^\d+$/)
      self.new.sync! webmotors_id unless Rails.cache.exist? "#{self.cache_key}:#{webmotors_id}"
    end

    def fetch(webmotors_id)
      check_argument webmotors_id
      JSON.parse cached_fetch(webmotors_id)
    end

    def sync!(webmotors_id)
      check_argument webmotors_id

      ActiveRecord::Base.transaction do
        make = Make.find_by! webmotors_id: webmotors_id
        fetch(webmotors_id).each { |item| create make, item }
      end
    end

    private

    def check_argument(webmotors_id)
      raise ArgumentError, "invalid argument type" unless webmotors_id.to_s.match(/^\d+$/)
    end

    def cached_fetch(webmotors_id)
      Rails.cache.fetch "#{self.cache_key}:#{webmotors_id}" do
        response = Net::HTTP.post_form URI(self.base_uri), { marca: webmotors_id }
        response.body
      end
    end

    def create(make, item)
      make.models.create! name: item["Nome"]
    rescue ActiveRecord::RecordNotUnique
      Rails.logger.debug "Record already registered: #{item.inspect}"
    rescue Exception => e
      Rails.logger.debug "Resource invalid to import: #{item.inspect}. Reason: #{e.message}"
    end
  end
end