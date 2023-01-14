class IssuesController < ApplicationController
  require 'net/http'
  require 'uri'

  before_action :define_issue , only: [:show, :edit, :update, :destroy]

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
    if @issue.save
      redirect_to issues_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def show
    issue_details_from_jira
    if @response_output_issues.key?('errors')
      flash.alert = "Please check if #{@issue.jiraid} exists and is available on JIRA"
      no_api_reponse
    else
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
      flash.alert = 'Admin access only'
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
      :status,
      :time_spent
    )
  end

  def issue_details_from_jira
    url = URI.parse("https://agenceinspire.atlassian.net/rest/api/3/issue/#{@issue.jiraid}")
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
    @issue_owner = Owner.find_by(params[:current_user])

  end

  def no_api_reponse
    @api_issuekey = 'No data from the API.'
    @api_time_spent = 'No data from the API.'
    @api_time_estimate = 'No data from the API.'
    @api_remaining_estimate = 'No data from the API.'
    @api_project_name = 'No data from the API.'
    @api_date_created = 'No data from the API.'
    @api_display_name = 'No data from the API.'
    @api_status = 'No data from the API.'
    @api_issue_creator = 'No data from the API.'
    @api_summary = 'No data from the API.'
  end


  def yes_api_response
    @api_issuekey = @response_output_issues['key']
    @api_time_spent = @response_output_issues['fields']['timespent']
    @api_time_estimate = @response_output_issues['fields']['originalEstimate']
    @api_remaining_estimate= @response_output_issues['fields']['timetracking']['remainingEstimate']
    @api_project_name = @response_output_issues['fields']['project']['name']
    @api_date_created = @response_output_issues['fields']['created']
    @api_display_name = @response_output_issues['fields']['assignee']['displayName']
    @api_status = @response_output_issues['fields']['status']['name']
    @api_issue_creator = @response_output_issues['fields']['creator']['displayName']
    @api_summary = @response_output_issues['fields']['summary']
  end
end
