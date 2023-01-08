class IssuesController < ApplicationController
  require 'net/http'
  require 'uri'
  require 'json'

  before_action :define_issue , only: [:show]

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
    issue_details_from_jira
    if @response_output_issues.has_key?("errors")
      flash.alert = "Please check if #{@issue.jiraid} exists and is available on JIRA"
      @api_issuekey = "No data from the API."
      @api_time_spent = "No data from the API."
      @api_time_estimate = "No data from the API."
      @api_remaining_estimate = "No data from the API."
      @api_project_name = "No data from the API."
      @api_date_created = "No data from the API."
      @api_display_name = "No data from the API."
      @api_status = "No data from the API."
      @api_issue_creator = "No data from the API."
      @api_summary = "No data from the API."
    else
      @api_issuekey = @response_output_issues["key"]
      @api_time_spent = @response_output_issues["fields"]["timespent"]
      @api_time_estimate = @response_output_issues["fields"]["originalEstimate"]
      @api_remaining_estimate= @response_output_issues["fields"]["timetracking"]["remainingEstimate"]
      @api_project_name = @response_output_issues["fields"]["project"]["name"]
      @api_date_created = @response_output_issues["fields"]["created"]
      @api_display_name = @response_output_issues["fields"]["assignee"]["displayName"]
      @api_status = @response_output_issues["fields"]["status"]["name"]
      @api_issue_creator = @response_output_issues["fields"]["creator"]["displayName"]
      @api_summary = @response_output_issues["fields"]["summary"]
    end
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

  def issue_details_from_jira
    url = URI.parse("https://agenceinspire.atlassian.net/rest/api/latest/issue/#{@issue.jiraid}")
    headers = {
      'Authorization' =>  "Basic #{ENV['JIRA_API_TOKEN']}",
      'Content-Type' => 'application/json'
    }

    request = Net::HTTP::Get.new(url, headers)

    response = Net::HTTP.start(url.hostname, url.port, use_ssl: true) do |http|
      http.request(request)
    end

    @response_output_issues = JSON.parse(response.body)
  end


  def define_issue
    @issue = Issue.find(params[:id])
    @project = Project.find_by(name: @issue.project)
    @owner = Owner.find_by(name: @issue.owner)
  end

end
