class DepartementsController < ApplicationController
  before_action :admin_only_access

  def index
    @departements = Departement.all.order(created_at: :desc)
  end

  def new
    @departement = Departement.new
  end

  def create
    @departement = Departement.new(departement_params)
    if @departement.save
      redirect_to departements_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @departement = Departement.find(params[:id])
  end

  def show
    @departement = Departement.find(params[:id])
  end

  def update
    @departement = Departement.find(params[:id])

    if @departement.update(departement_params)
      redirect_to departements_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @departement = Departement.find(params[:id])
    @departement.destroy

    redirect_to departements_path
  end

  private

  def departement_params
    params.require(:departement).permit(:name)
  end
end
