require 'rails_helper'

RSpec.describe "models/index.html.erb", type: :view do
  it "generates error when not pass params" do
    Model.delete_all
    Make.delete_all

    expect { render }.to raise_error("undefined method `id' for nil:NilClass")
  end

  it "generates error when not pass invalid params" do
    Model.delete_all
    Make.delete_all

    make = Make.create webmotors_id: 1, name: 'Fiat'
    Model.create make_id: make.id, name: 'Palio'
    Model.create make_id: make.id, name: 'Uno'

    controller.params.merge! webmotors_make_id: (make.webmotors_id + 1)

    expect { render }.to raise_error("undefined method `id' for nil:NilClass")
  end

  it "Retrieve data from make models" do
    Model.delete_all
    Make.delete_all

    make = Make.create webmotors_id: 1, name: 'Fiat'
    Model.create make_id: make.id, name: 'Palio'
    Model.create make_id: make.id, name: 'Uno'

    controller.params.merge! webmotors_make_id: make.webmotors_id
    render

    expect(rendered).to match %r{<li>Palio</li>}
    expect(rendered).to match %{<li>Uno</li>}
  end

  it "must have back button" do
    Model.delete_all
    Make.delete_all

    make = Make.create webmotors_id: 1, name: 'Fiat'
    controller.params.merge! webmotors_make_id: make.webmotors_id

    render

    expect(rendered).to match %r{<a href="/"[^>]*><< Voltar</a>}
  end
end
