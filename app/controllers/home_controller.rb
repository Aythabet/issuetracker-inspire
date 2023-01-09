class HomeController < ApplicationController
  require 'net/http'
  require 'uri'

  def index
  end

  def jira
  end

  private

  def get_projects(start)
    url = URI.parse("https://agenceinspire.atlassian.net/rest/api/3/project/search?startAt=#{start}&maxResults=50")
    headers = {
      'Authorization' =>  "Basic #{ENV['JIRA_API_TOKEN']}",
      'Content-Type' => 'application/json'
    }

    request = Net::HTTP::Get.new(url, headers)

    response = Net::HTTP.start(url.hostname, url.port, use_ssl: true) do |http|
      http.request(request)
    end

    response_output_issues = JSON.parse(response.body)
    collect_projects(response_output_issues)
  end

  def collect_projects(output_array)
    i = 0
    while i < output_array["values"].length
      @project_key = output_array["values"][i]["key"]
      @project_name = output_array["values"][i]["name"]
      @project_jira_link = output_array["values"][i]["self"]
      @collected_projects << [@project_key, @project_name, @project_jira_link]
      i += 1
    end
  end
end
