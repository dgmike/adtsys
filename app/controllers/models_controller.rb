class ModelsController < ApplicationController
  before_action :sync_models, only: [:index]

  def index
    @models = Make.includes(:models).find_by!(webmotors_id: params[:webmotors_make_id]).models
  end

  private

  def sync_models
    Webmotors::ModelosService.sync! params[:webmotors_make_id]
  end
end
