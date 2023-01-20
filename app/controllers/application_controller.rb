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
    url = URI.parse("#{url}")
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
end
