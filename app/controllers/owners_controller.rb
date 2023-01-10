class OwnersController < ApplicationController
  def index
    @owners = Owner.all.order(created_at: :desc).page params[:page]
  end

  def new
    admin_only_access
    @owner = Owner.new
  end

  def create
    @owner = Owner.new(owner_params)
    if @owner.save
      redirect_to owners_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @owner = Owner.find(params[:id])
    if current_user.email == @owner.email
      @owner
    else
      admin_only_access
    end
  end

  def update
    @owner = Owner.find(params[:id])
    if @owner.update(owner_params)
      redirect_to owners_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def show
    @owners = Owner.all.order(created_at: :desc).page params[:page]
    define_owner
    @total_estimation = 0
    @total_real = 0
    @issuesowner.each do |owner|
      @total_estimation += owner.time_forecast
      @total_real += owner.time_real
    end
  end

  def destroy
    return unless current_user.admin?

    @owner = Owner.find(params[:id])
    @owner.destroy
    redirect_to owners_path
  end

  private

  def owner_params
    params.require(:owner).permit(:name, :departement, :jiraid, :email, :status, :date_joined_jira, :last_seen_on_jira)
  end

  def define_owner
    @owner = Owner.find(params[:id])
    @issuesowner = Issue.where(owner: @owner.name).order(created_at: :desc).page params[:page]
  end
end
