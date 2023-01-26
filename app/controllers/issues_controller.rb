class IssuesController < ApplicationController
  require 'net/http'
  require 'uri'

  before_action :define_issue , only: [:show, :edit, :update, :destroy]
  before_action :admin_only_access, only: [:destroy]

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

  def create
    @issue = Issue.new(issue_params)

    # Check if issue exists on JIRA
    unless call_jira_api("https://agenceinspire.atlassian.net/rest/api/3/issue/#{@issue.jiraid}")
      flash.alert = "Please check if #{@issue.jiraid} exists and is available on JIRA"
    end

    # Get issue details from JIRA
    get_issue_details_from_jira
    get_issue_time_real_from_jira

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

  def show
    call_jira_api("https://agenceinspire.atlassian.net/rest/api/3/issue/#{@issue.jiraid}")
    if @response_output_issues.key?('errors')
      flash.alert = "Please check if #{@issue.jiraid} exists and is available on JIRA"
      no_api_reponse
    else
      get_issue_details_from_jira
      yes_api_response
    end
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

  def no_api_reponse
    @api_issuekey = 'No data from the API.'
    @api_project_name = 'No data from the API.'
    @api_date_created = 'No data from the API.'
    @api_display_name = 'No data from the API.'
    @api_status = 'No data from the API.'
    @api_issue_creator = 'No data from the API.'
    @api_summary = 'No data from the API.'
  end

  def yes_api_response
    @api_issuekey = @response_output_issues['key']
    @api_project_name = @response_output_issues['fields']['project']['name']
    @api_date_created = @response_output_issues['fields']['created']
    @api_display_name = @response_output_issues['fields']['assignee']['displayName']
    @api_issue_creator = @response_output_issues['fields']['creator']['displayName']
    @api_summary = @response_output_issues['fields']['summary']
  end

  def get_issue_time_real_from_jira
    call_jira_api("https://agenceinspire.atlassian.net/rest/api/3/issue/#{@issue.jiraid}/worklog")
    worklogs = @response_output_issues["worklogs"]
    total_time_spent = 0
    if worklogs != []
      worklogs.each do |worklog|
        total_time_spent += worklog["timeSpentSeconds"].to_f / 3600
        @issue.time_real = total_time_spent
        @api_time_real = "#{@issue.time_real} hours"
      end
    else
      flash.alert = "No worklog found for issue: #{@issue.jiraid}"
      render :new
    end
  end

  def get_issue_details_from_jira
    # get time_forecast field
    if @response_output_issues["fields"]["timetracking"].key?("originalEstimateSeconds")
      @issue.time_forecast = @response_output_issues["fields"]["timetracking"]["originalEstimateSeconds"]  / 3600
      @api_time_estimate = "#{@issue.time_forecast} hours"
    else
      flash.alert = "No worklog found for issue: #{@issue.jiraid}"
      render :new
    end

    # get status field
    if @response_output_issues['fields']['status']['name']
      @issue.status = @response_output_issues['fields']['status']['name']
      @api_status = @issue.status
    else
      flash.alert = "Status can't be found. Please check if #{@issue.jiraid} exists and is available on JIRA"
      render :new
    end

    # get project field
    if @response_output_issues['fields']['project']['key']
      project_key = @response_output_issues['fields']['project']['key']
      @issue.project = Project.find_by(jiraid: project_key)
      @api_project_name = @issue.project.id
    else
      flash.alert = "Project can't be found. Please check if #{@issue.jiraid} exists and is available on JIRA"
      render :new
    end
  end
end
