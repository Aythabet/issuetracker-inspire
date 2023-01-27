class IssuesController < ApplicationController
  require 'net/http'
  require 'uri'

  before_action :define_issue, only: [:show, :edit, :update, :destroy]
  before_action :admin_only_access, only: [:destroy, :edit, :update]

  def index
    @issues = Issue.all.order(created_at: :desc).page params[:page]
  end

  def search
    if params[:search].blank?
      redirect_to issues_path and return
    else
      @parameter = params[:search].downcase
      @results = Issue.all.where('lower(jiraid) LIKE :search', search: "%#{@parameter}%").page params[:page]
    end
  end

  def new
    @issue = Issue.new
  end

  def show
    call_jira_api("https://agenceinspire.atlassian.net/rest/api/3/issue/#{@issue.jiraid}")
    if @response_output_issues.key?('errors')
      flash.alert = "Please check if #{@issue.jiraid} exists and is available on JIRA"
      no_api_reponse
    else
      issue_details_from_jira(@issue)
      yes_api_response
    end
  end

  def create
    @issue = Issue.new(issue_params)

    # Check if issue exists on JIRA
    unless call_jira_api("https://agenceinspire.atlassian.net/rest/api/3/issue/#{@issue.jiraid}")
      flash.alert = "Please check if #{@issue.jiraid} exists and is available on JIRA"
    end

    # Get issue details from JIRA
    issue_details_from_jira(@issue)
    issue_time_real_from_jira(@issue)

    # Save the issue
    if @issue.save
      flash.notice = "Issue #{@issue.jiraid} created"
      redirect_to issues_path and return
    else
      flash.alert = "There was a problem saving #{@issue.jiraid}, check if all the fields are filled on the JIRA issue"
    end
  end

  def edit
  end

  def update
    if @issue.update(issue_params)
      redirect_to issues_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if current_user.admin?
      @issue.destroy
    else
      admin_only_access
    end
    previous_page
  end

  private

  def issue_params
    params.require(:issue).permit(
      :jiraid,
      :project_id,
      :owner_id,
      :time_forecast,
      :time_real,
      :departement,
      :retour_test,
      :status
    )
  end

  def define_issue
    @issue = Issue.find(params[:id])
    @issue_owner = Owner.find_by(params[:current_user])
  end
end
