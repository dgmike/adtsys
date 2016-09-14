require 'rails_helper'

RSpec.describe Webmotors::MarcasService, type: :model do
  describe "#fetch" do
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

  describe "#sync" do
    it "must respond to :sync" do
      expect(subject).to respond_to :sync!
    end

    it "must run :fetch as dependency" do
      expect(subject).to receive(:fetch) { [] }

      subject.sync!
    end

    it "must create Makes for each fetch result" do
      Make.delete_all
      response_data = [
        { "Id" => 1, "Nome" => "Fiat" },
        { "Id" => 2, "Nome" => "Ford" }
      ]
      expect(subject).to receive(:fetch) { response_data }

      subject.sync!

      expect(Make.count).to eq 2
      expect(Make.first.as_json(only: [:name])["name"]).to eq("Fiat")
      expect(Make.first.as_json(only: [:webmotors_id])["webmotors_id"]).to eq(1)
      expect(Make.second.as_json(only: [:name])["name"]).to eq("Ford")
      expect(Make.second.as_json(only: [:webmotors_id])["webmotors_id"]).to eq(2)
    end

    it "must skip invalid responses" do
      Make.delete_all
      response_data = [
        { "Id" => 1 },
        { "Nome" => "Ford" },
        {},
        { "Id" => 1, "Nome" => "Fiat" }, # valid in the middle ;)
        { "Invalid" => "yes" },
      ]
      expect(subject).to receive(:fetch) { response_data }

      subject.sync!

      expect(Make.count).to eq 1
    end

    it "must skip repeated items" do
      Make.delete_all
      Make.create name: "Fiat", webmotors_id: 1

      response_data = [
        { "Id" => 1, "Nome" => "Fiat" }
      ]
      expect(subject).to receive(:fetch) { response_data }

      subject.sync!

      expect(Make.count).to eq 1
    end

    it "must log as debug when resource exists" do
      Make.delete_all
      Make.create name: "Fiat", webmotors_id: 1

      response_data = [
        { "Id" => 1, "Nome" => "Fiat" }
      ]
      expect(subject).to receive(:fetch) { response_data }
      expect(Rails.logger).to receive(:debug).with('Record already registered: {"Id"=>1, "Nome"=>"Fiat"}')

      subject.sync!

      expect(Make.count).to eq 1
    end

    it "must log as debug when resource invalid" do
      Make.delete_all
      Make.create name: "Fiat", webmotors_id: 1

      response_data = [
        { "Invalid" => true }
      ]
      expect(subject).to receive(:fetch) { response_data }
      expect(Rails.logger).to receive(:debug).with('Resource invalid to import: {"Invalid"=>true}. Reason: Validation failed: Name can\'t be blank, Webmotors can\'t be blank')

      subject.sync!

      expect(Make.count).to eq 1
    end
  end

  describe ":sync!" do
    it "must create new self instance and call #sync! method" do
      mock_instance = double(subject, "sync!": true)
      expect(subject.class).to receive(:new) { mock_instance }

      result = subject.class.sync!
      expect(result).to be_truthy
    end
  end
end
