class HomeController < ApplicationController
  require 'net/http'
  require 'uri'

  def index
  end

  def jira
    @collected_projects_hash = {}
    url_start_at0 = 'https://agenceinspire.atlassian.net/rest/api/3/project/search?startAt=0&maxResults=50&expand=lead'
    url_start_at50 = 'https://agenceinspire.atlassian.net/rest/api/3/project/search?startAt=50&maxResults=50&expand=lead'
    parse_projects(call_jira_api(url_start_at0))
    parse_projects(call_jira_api(url_start_at50))
    @collected_projects_hash
  end

  private

  def parse_projects(output_array)
    i = 0
    while i < output_array['values'].length
      project_key = output_array['values'][i]['key']
      project_name = output_array['values'][i]['name']
      #      api_lead_data = call_jira_api(project_self)
      project_lead = output_array['values'][i]['lead']['displayName']
      @collected_projects_hash[project_key] = {
        key: project_key,
        name: project_name,
        lead: project_lead
      }
      i += 1
    end
  end
end
