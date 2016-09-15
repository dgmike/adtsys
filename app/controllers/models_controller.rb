class ModelsController < ApplicationController
  def index
    Webmotors::ModelosService.sync! params[:webmotors_make_id]
  end
end
