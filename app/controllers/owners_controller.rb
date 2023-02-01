class OwnersController < ApplicationController
  before_action :define_owner, only: [:edit, :update, :destroy, :show]
  before_action :admin_only_access, only: [:new, :create, :destroy]

  def index
    @owners = Owner.all.order(created_at: :desc).page params[:page]
  end

  def new
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
    if current_user.email == @owner.user.email
      @owner
    else
      admin_only_access
    end
  end

  def update
    if @owner.update(owner_params)
      redirect_to owners_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def show
    @dailyreports = Dailyreport.where(owner_id: params[:id]).all
    @total_estimation = 0
    @total_real = 0
    @total_tasks = 0
    @total_tasks_duration = 0
    @total_meetings = 0
    @total_meetings_duration = 0
    @total_trainings = 0
    @total_trainings_duration = 0
    @owner.issues.each do |issue|
      @total_estimation += issue.time_forecast
      @total_real += issue.time_real
      case issue.issue_type
      when 'Task'
        @total_tasks += 1
        @total_tasks_duration += issue.time_real
      when 'Meeting'
        @total_meetings += 1
        @total_meetings_duration += issue.time_real
      when 'Training', 'Self-training'
        @total_trainings += 1
        @total_trainings_duration += issue.time_real
      end
    end
  end

  def destroy
    return unless current_user.admin?

    @owner.destroy
    redirect_to owners_path
  end

  private

  def owner_params
    params.require(:owner).permit(:name, :jiraid, :status, :date_joined_jira, :last_seen_on_jira)
  end

  def define_owner
    @owner = Owner.find(params[:id])
  end
end
