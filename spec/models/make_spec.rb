require 'rails_helper'

RSpec.describe Make, type: :model do
  it "must have models" do
    make = Make.new

    expect(make).to respond_to :models
  end

  it "must accept create models" do
    make = Make.new

    expect(make.models).to respond_to :create
  end

  it "must create models" do
    Make.delete_all
    Model.delete_all

    make = Make.create name: "Fiat", webmotors_id: 1
    make.models.create name: 'Uno'
    make.models.create name: 'Palio'

    expect(Model.count).to eq 2
  end

  it "must validate presence of name" do
    make = Make.new

    expect(make.valid?).to be_falsy
    expect(make.errors.keys).to include :name
    expect(make.errors[:name]).to include "can't be blank"
  end

  it "must validate presence of webmotors_id" do
    make = Make.new

    expect(make.valid?).to be_falsy
    expect(make.errors.keys).to include :webmotors_id
    expect(make.errors[:webmotors_id]).to include "can't be blank"
  end

  it "throw error when duplicated" do
    Make.delete_all
    Make.create name: "Fiat", webmotors_id: 1

    expect { Make.create name: "Fiat", webmotors_id: 1 }.to raise_error ActiveRecord::RecordNotUnique
  end
end
