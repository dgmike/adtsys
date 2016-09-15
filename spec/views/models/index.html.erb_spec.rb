require 'rails_helper'

RSpec.describe "models/index.html.erb", type: :view do
  it "Retrieve data from make models" do
    Model.delete_all
    Make.delete_all

    make = Make.create webmotors_id: 1, name: 'Fiat'
    Model.create make_id: make.id, name: 'Palio'
    Model.create make_id: make.id, name: 'Uno'

    assign(:models, Model.all)
    render

    expect(rendered).to match %r{<li>Palio</li>}
    expect(rendered).to match %{<li>Uno</li>}
  end

  it "must have back button" do
    assign(:models, [])

    render

    expect(rendered).to match %r{<a href="/"[^>]*>&lt;&lt; Voltar</a>}
  end
end
