require 'rails_helper'

RSpec.describe Webmotors::ModelosService do
  describe "#fetch" do
    it "must respond to :fetch"
    it "must cache response"
    it "must require one argument as numeral"
    it "must post on Webmotors API"
    it "must post on Webmotors API using argument"
  end

  describe "#sync!" do
    it "must respond to :sync!"
    it "must require one argument as numeral"
    it "must call :fetch with argument"
    it "must create Models based on :fetch response"
    it "must skip duplicated results"
    it "must log duplicated results"
    it "must log invalid results"
  end
end