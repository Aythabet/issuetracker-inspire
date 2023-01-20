class HomeController < ApplicationController
  require 'net/http'
  require 'uri'

  def index
  end

  def jira
    @collected_projects_hash = Rails.cache.fetch("jira_projects", expires_in: 12.hours) do
      projects_hash = {}
      url_start_at0 = 'https://agenceinspire.atlassian.net/rest/api/3/project/search?startAt=0&maxResults=50'
      url_start_at50 = 'https://agenceinspire.atlassian.net/rest/api/3/project/search?startAt=50&maxResults=50'
      parse_projects(call_jira_api(url_start_at0), projects_hash)
      parse_projects(call_jira_api(url_start_at50), projects_hash)
      projects_hash
    end
  end

  private

  def parse_projects(output_array, projects_hash)
    i = 0
    while i < output_array['values'].length
      project_key = output_array['values'][i]['key']
      project_name = output_array['values'][i]['name']
      project_self = output_array['values'][i]['self']
      api_lead_data = call_jira_api(project_self)
      project_lead = api_lead_data['lead']['displayName']
      projects_hash[project_key] = {
        key: project_key,
        name: project_name,
        self: project_self,
        lead: project_lead
      }
      i += 1
    end
  end
end
