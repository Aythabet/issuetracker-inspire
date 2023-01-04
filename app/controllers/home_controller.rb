class HomeController < ApplicationController
	require 'net/http'
	require 'uri'

	def index
		url = URI.parse('https://agenceinspire.atlassian.net/rest/api/2/project')
		p("Basic #{ENV["JIRA_API_TOKEN"]}",)
		headers = {
		  'Authorization' =>  "Basic #{ENV["JIRA_API_TOKEN"]}",
		  'Content-Type' => 'application/json'
		}

		request = Net::HTTP::Get.new(url, headers)

		response = Net::HTTP.start(url.hostname, url.port, use_ssl: true) do |http|
		  http.request(request)
		end

		@reponse_output = JSON.parse(response.body)
		@collected_projects = []

		@reponse_output.each do |project|
	      @project_name = project['name']
	      @project_key = project['key']

	      @collected_projects << [@project_key, @project_name]
	    end
	end
end


