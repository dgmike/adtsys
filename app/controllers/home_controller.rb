class HomeController < ApplicationController
  def index
    Webmotors::MarcasService.sync!
    @makes = Make.all
  end
end
