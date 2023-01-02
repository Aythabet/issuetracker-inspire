class ProjectsController < ApplicationController
  def index
    @projects = Project.all.order(created_at: :desc)
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
    @project = Project.find(params[:id])
  end

  def show
    @project = Project.find(params[:id])
    @projectissues = Issue.where(project: @project.name)
    @total_estimation = 0
    @total_real  = 0
    @projectissues.each do |issue|
      @total_estimation = @total_estimation + issue.time_forecast
      @total_real = @total_real + issue.time_real
   end
  end

  def update
    @project = Project.find(params[:id])

    if @project.update(project_params)
      redirect_to projects_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @project = Project.find(params[:id])
    @project.destroy

    redirect_to projects_path
  end


  private

  def project_params
    params.require(:project).permit(:name, :jiraid)
  end
end
