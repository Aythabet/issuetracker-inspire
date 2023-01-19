class HomeController < ApplicationController
  require 'net/http'
  require 'uri'

  def index
  end

  def jira
    @collected_projects = []
    url_start_at_0 = "https://agenceinspire.atlassian.net/rest/api/3/project/search?startAt=0&maxResults=50"
    url_start_at_50 = "https://agenceinspire.atlassian.net/rest/api/3/project/search?startAt=50&maxResults=50"
    parse_projects(call_jira_api(url_start_at_0))
    parse_projects(call_jira_api(url_start_at_50))
    i = 0
    @collected_projects.each do |project, i|
      lead_api = call_jira_api(@project_self)
      @project_lead = lead_api["lead"]["displayName"]
      @collected_projects[i] << @project_lead
      i += 1
    end

  end

  private

  def parse_projects(output_array)
    i = 0
    while i < output_array["values"].length
      @project_key = output_array["values"][i]["key"]
      @project_name = output_array["values"][i]["name"]
      @project_self = output_array["values"][i]["self"]
      @collected_projects << [@project_key, @project_name, @project_self]
      i += 1
    end
  end
end
