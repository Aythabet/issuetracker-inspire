class OwnersController < ApplicationController
  def index
    @owners = Owner.all.order(created_at: :desc).page params[:page]
  end

  def new
    admin_only_access
    @owner = Owner.new
  end

  def create
    admin_only_access
    @owner = Owner.new(owner_params)
    if @owner.save
      redirect_to owners_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    admin_only_access
    @owner = Owner.find(params[:id])
  end

  def show
    @owner = Owner.find(params[:id])
    @issuesowner = Issue.where(owner: @owner.name)
    @total_estimation = 0
    @total_real  = 0
    @issuesowner.each do |owner|
      @total_estimation = @total_estimation + owner.time_forecast
      @total_real = @total_real + owner.time_real
    end
  end

  def update
    admin_only_access
    @owner = Owner.find(params[:id])

    if @owner.update(owner_params)
      redirect_to owners_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if current_user.admin == true
      @owner = Owner.find(params[:id])
      @owner.destroy
      redirect_to owners_path
    else
      flash.alert = "Admin access only"
      previous_page
    end
  end

  private

  def owner_params
    params.require(:owner).permit(:name, :speciality)
  end
end
