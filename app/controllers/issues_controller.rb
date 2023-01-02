class IssuesController < ApplicationController
  def index
    @issues = Issue.all.order(created_at: :desc)
  end

  def new
    @issue = Issue.new
  end

  def create
    @issue = Issue.new(issue_params)
    if @issue.save
      redirect_to issues_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @issue = Issue.find(params[:id])
  end

  def show
    @issue = Issue.find(params[:id])
  end

  def update
    @issue = Issue.find(params[:id])

    if @issue.update(issue_params)
      redirect_to issues_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @issue = Issue.find(params[:id])
    @issue.destroy

    redirect_to root_path
  end

  private

  def issue_params
    params.require(:issue).permit(:jiraid, :project, :owner, :time_forecast, :time_real,:departement)
  end
end