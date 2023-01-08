class HomeController < ApplicationController
  require 'net/http'
  require 'uri'

  def index
  end

  def jira
    url = URI.parse("https://agenceinspire.atlassian.net/rest/api/2/issue/AC-301")
    headers = {
      'Authorization' =>  "Basic #{ENV['JIRA_API_TOKEN']}",
      'Content-Type' => 'application/json'
    }

    request = Net::HTTP::Get.new(url, headers)

    response = Net::HTTP.start(url.hostname, url.port, use_ssl: true) do |http|
      http.request(request)
    end

    @response_output_issues = JSON.parse(response.body)
    @this_issue = @response_output_issues["key"]
  end

  def issues
  end
end
