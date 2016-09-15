class ModelsController < ApplicationController
  before_action :sync_models, only: [:index]

  def index
  end

  private

  def sync_models
    Webmotors::ModelosService.sync! params[:webmotors_make_id]
  end
end
