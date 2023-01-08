class HomeController < ApplicationController
  require 'net/http'
  require 'uri'
  require 'json'

  def index
  end

  def jira
    url = URI.parse("https://agenceinspire.atlassian.net/rest/api/latest/users")
    headers = {
      'Authorization' =>  "Basic #{ENV['JIRA_API_TOKEN']}",
      'Content-Type' => 'application/json'
    }

    request = Net::HTTP::Get.new(url, headers)

    response = Net::HTTP.start(url.hostname, url.port, use_ssl: true) do |http|
      http.request(request)
    end

    @response_output_issues = JSON.parse(response.body)

    @collected_users = []
    i = 0
    while i < @response_output_issues.length
      @jira_user_name = @response_output_issues[i]["displayName"]
      @collected_users << @jira_user_name
      i += 1
    end
  end

  def issues
  end
end
