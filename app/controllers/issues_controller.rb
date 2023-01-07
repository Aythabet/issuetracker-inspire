class IssuesController < ApplicationController

  def index
    @issues = Issue.all.order(created_at: :desc).page params[:page]
  end

  def search
    if params[:search].blank?
      redirect_to issues_path and return
    else
      @parameter = params[:search].downcase
      @results = Issue.all.where("lower(jiraid) LIKE :search", search: "%#{@parameter}%").page params[:page]
    end
  end

  def new
    admin_only_access
    @issue = Issue.new
  end

  def create
    admin_only_access
    @issue = Issue.new(issue_params)
    if @issue.save
      redirect_to issues_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    admin_only_access
    @issue = Issue.find(params[:id])
  end

  def show
    @issue = Issue.find(params[:id])
  end

  def update
    admin_only_access
    @issue = Issue.find(params[:id])

    if @issue.update(issue_params)
      redirect_to issues_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if current_user.admin == true
      @issue = Issue.find(params[:id])
      @issue.destroy
      redirect_to root_path
    else
      flash.alert = "Admin access only"
      previous_page
    end
  end

  private

  def issue_params
    params.require(:issue).permit(:jiraid, :project, :owner, :time_forecast, :time_real,:departement, :retour_test)
  end
end
