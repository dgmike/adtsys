class HomeController < ApplicationController
  def index
    Webmotors::MarcasService.sync!
  end
end
