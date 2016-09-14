require 'rails_helper'

RSpec.describe "home/index.html.erb", type: :view do
  it "create select with all makes" do
    Make.delete_all
    Make.create id: 7, webmotors_id: 1, name: 'Marca 1'
    Make.create id: 8, webmotors_id: 2, name: 'Marca 2'
    Make.create id: 9, webmotors_id: 3, name: 'Marca 3'

    assign :makes, Make.all
    render

    expect(rendered).to match %r{<select name="webmotors_make_id"[^>]*>}
    expect(rendered).to match %r{<option value="1">Marca 1</option>}
    expect(rendered).to match %r{<option value="2">Marca 2</option>}
    expect(rendered).to match %r{<option value="3">Marca 3</option>}
  end

  it "renders a form to /models" do
    assign :makes, []
    render

    expect(rendered).to match %r{form action="/models"}
  end

  it "renders a submit buttom" do
    assign :makes, []
    render

    expect(rendered).to match %r{<input type="submit".*value="Buscar modelos".*>}
  end

  it "must render a label" do
    assign :makes, []
    render

    expect(rendered).to match %r{<label[^>]*>Escolha a Fabricante:</label>}
  end
end
