class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  def admin_only_access
    return unless current_user.admin == false
    flash.alert = 'Admin access only'
    previous_page
  end

  def previous_page
    if request.env['HTTP_REFERER'].nil?
      redirect_to root_path
    else
      redirect_to(request.env['HTTP_REFERER'])
    end
  end

  def active_path
    if request.env['PATH_INFO'].nil?
      redirect_to root_path
    else
      redirect_to(request.env['PATH_INFO'])
    end
  end

  def call_jira_api(url)
    url = URI.parse(url.to_s)
    headers = {
      'Authorization' =>  "Basic #{ENV['JIRA_API_TOKEN']}",
      'Content-Type'  =>  'application/json'
    }
    request = Net::HTTP::Get.new(url, headers)
    response = Net::HTTP.start(url.hostname, url.port, use_ssl: true) do |http|
      http.request(request)
    end
    @response_output_issues = JSON.parse(response.body)

    return unless @response_output_issues.key?('errors')

    no_api_reponse
    flash.alert = 'Please check if the issue exists and is available on JIRA'
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

  def issue_details_from_jira(issue)
    # get time_forecast field
    issue.time_forecast = 'No data on JIRA'
    if @response_output_issues['fields']['timetracking']['originalEstimateSeconds']
      issue.time_forecast = @response_output_issues['fields']['timetracking']['originalEstimateSeconds'] / 3600
      @api_time_estimate = "#{issue.time_forecast} hours"
    else
      flash.alert = "No worklog found for issue: #{issue.jiraid}"
    end

    # get status field
    if @response_output_issues['fields']['status']['name']
      issue.status = @response_output_issues['fields']['status']['name']
      @api_status = issue.status
    else
      flash.alert = "Status can't be found. Please check if #{issue.jiraid} exists and is available on JIRA"
    end

    # get project field
    if @response_output_issues['fields']['project']['key']
      project_key = @response_output_issues['fields']['project']['key']
      issue.project = Project.find_by(jiraid: project_key)
      @api_project_name = issue.project.id
    else
      flash.alert = "Project can't be found. Please check if #{issue.jiraid} exists and is available on JIRA"
    end
  end

  def issue_time_real_from_jira(issue)
    call_jira_api("https://agenceinspire.atlassian.net/rest/api/3/issue/#{issue.jiraid}/worklog")
    worklogs = @response_output_issues["worklogs"]
    issue.time_real = 'No data on JIRA'
    total_time_spent = 0
    if worklogs != []
      worklogs.each do |worklog|
        total_time_spent += worklog["timeSpentSeconds"].to_f / 3600
        issue.time_real = total_time_spent
        @api_time_real = "#{issue.time_real} hours"
      end
    else
      flash.alert = "No worklog found for issue: #{issue.jiraid}"
    end
  end
end
