class ProjectsController < ApplicationController
  before_action :admin_only_access
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
    @project.issues.each do |issue|
      @total_estimation = @total_estimation + issue.time_forecast
      @total_real = @total_real + issue.time_real
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
    @project.destroy

    redirect_to projects_path
  end


  private

  def project_params
    params.require(:project).permit(:name, :jiraid, :link)
  end

  def define_owner
    @project = Project.find(params[:id])
  end
end
