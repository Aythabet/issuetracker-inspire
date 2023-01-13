class DailyreportsController < ApplicationController
  before_action :define_dailyreport , only: [:edit, :show, :update, :destroy]

  def index
    @dailyreports = Dailyreport.all.order(created_at: :desc).page params[:page]
  end

  def new
    @dailyreport = Dailyreport.new
  end

  def create
    @dailyreport = Dailyreport.new(dailyreport_params)
    if @dailyreport.save
      redirect_to dailyreports_path
    else
      flash.alert = 'Action not performed, there was a problem.'
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def show
  end

  def update
    if @dailyreport.update(dailyreport_params)
      redirect_to dailyreports_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if current_user.admin?
      @dailyreport.destroy
    else
      flash.alert = 'Admin access only'
    end
    previous_page
  end

  private

  def dailyreport_params
    params.require(:dailyreport).permit(:comment, :owner_id)
  end

  def define_dailyreport
    @dailyreport = Dailyreport.find(params[:id])
  end
end
