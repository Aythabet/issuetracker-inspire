class ProjectsController < ApplicationController
  before_action :admin_only_access
  before_action :admin_only_access, only: [:new, :create, :destroy, :edit, :update]

  def index
    @projects = Project.all.order(created_at: :desc).page params[:page]
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)
    if @project.save
      redirect_to projects_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    define_owner
  end

  def show
    define_owner
    @total_estimation = 0
    @total_real = 0
    @total_tasks = 1
    @total_tasks_duration = 0
    @total_meetings = 1
    @total_meetings_duration = 0
    @total_trainings = 1
    @total_trainings_duration = 0
    @project.issues.each do |issue|
      @total_estimation += issue.time_forecast
      @total_real += issue.time_real
      case issue.issue_type
      when 'Task'
        @total_tasks += @total_tasks
        @total_tasks_duration += @total_real
      when 'Meeting'
        @total_meetings += @total_tasks
        @total_meetings_duration += @total_real
      when 'Training', 'Self-training'
        @total_trainings += @total_tasks
        @total_trainings_duration += @total_real

      end
    end
  end

  def update
    define_owner
    if @project.update(project_params)
      redirect_to projects_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    define_owner
    if current_user.admin?
      @project = Project.find(params[:id])
      @project.destroy
    else
      flash.alert = 'Admin access only'
    end
    previous_page
  end

  private

  def project_params
    params.require(:project).permit(:name, :jiraid, :link)
  end

  def define_owner
    @project = Project.find(params[:id])
  end
end
