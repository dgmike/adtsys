class HomeController < ApplicationController
  before_action :sync_makes, only: :index

  def index
    @makes = Make.all
  end

  private

  def sync_makes
    Webmotors::MarcasService.sync!
  end
end
