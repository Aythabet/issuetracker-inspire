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
    @owner = Owner.find(params[:id])
    if current_user.email == @owner.email
      @owner
    else
      admin_only_access
    end
  end

  def update
    @owner = Owner.find(params[:id])
    if current_user.email == @owner.email
      if @owner.update(owner_params)
        redirect_to owner_path(@owner)
      else
        render :edit, status: :unprocessable_entity
      end
    else
      admin_only_access
    end
  end

  def show
    define_project
    @total_estimation = 0
    @total_real  = 0
    @issuesowner.each do |owner|
      @total_estimation = @total_estimation + owner.time_forecast
      @total_real = @total_real + owner.time_real
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
    params.require(:owner).permit(:name, :departement, :jiraid, :email, :status, :date_joined_jira, :last_seen_on_jira, )
  end

  def define_project
    @owner = Owner.find(params[:id])
    @issuesowner = Issue.where(owner: @owner.name)
  end

end
