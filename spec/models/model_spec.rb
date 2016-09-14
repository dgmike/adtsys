require 'rails_helper'

RSpec.describe Model, type: :model do
  it "must respond to make" do
    model = Model.new

    expect(model).to respond_to :make
  end

  it "must respond :make with Make instance" do
    Make.delete_all
    Model.delete_all

    make = Make.create webmotors_id: 1, name: "Fiat"
    Model.create name: "Uno", make_id: make.id

    expect(Model.take.make.id).to eq make.id
  end

  it "must validate presence of name" do
    model = Model.new

    expect(model.valid?).to be_falsy
    expect(model.errors.keys).to include :name
    expect(model.errors[:name]).to include "can't be blank"
  end

  it "must validate presence of make_id" do
    model = Model.new

    expect(model.valid?).to be_falsy
    expect(model.errors.keys).to include :make
    expect(model.errors[:make]).to include "can't be blank"
  end

  it "must throw error on duplicate" do
    Make.delete_all
    Model.delete_all

    make = Make.create name: "Fiat", webmotors_id: 1
    Model.create name: "Uno", make_id: make.id

    expect { Model.create name: "Uno", make_id: make.id }.to raise_error ActiveRecord::RecordNotUnique
  end
end
