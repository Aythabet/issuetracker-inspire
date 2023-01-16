class DailyreportsController < ApplicationController
  before_action :define_dailyreport , only: [:edit, :show, :update, :destroy]

  def index
    @dailyreports = Dailyreport.all.order(created_at: :desc).page params[:page]
  end

  def new
    @dailyreport = Dailyreport.new
    @dailyreport.issues.build
    @issues = Issue.all.order(created_at: :desc)

  end


  def edit
  end

  def show
  end

  def create
    @dailyreport = Dailyreport.new(dailyreport_params)
    if @dailyreport.save
      redirect_to @dailyreport, notice: 'Dailyreport was successfully created.'
    else
      render :new
    end
  end

  def update
    if @dailyreport.update(dailyreport_params)
      redirect_to @dailyreport, notice: 'Dailyreport was successfully updated.'
    else
      render :edit
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
    params.require(:dailyreport).permit(
      :comment,
      :owner_id,
      issues_attributes: [
        :jiraid,
        :project_id,
        :owner_id,
        :time_forecast,
        :time_real,
        :departement,
        :retour_test,
        :status,
        :time_spent
      ]
    )
  end

  def define_dailyreport
    @dailyreport = Dailyreport.find(params[:id])
  end
end
