class DailyreportsController < ApplicationController
  helper DailyreportsHelper
  before_action :define_dailyreport, only: [:edit, :show, :update, :destroy]

  def index
    @dailyreports = Dailyreport.all.order(created_at: :desc).page params[:page]
  end

  def new
    @dailyreport = Dailyreport.new
    @dailyreport.issues.build
    @issues = Issue.all.order(created_at: :desc)
  end

  def edit
  end

  def show
  end

  def owner_dailyreport
    @owner_dailyreport = current_user.owner.dailyreports
  end

  def create
    @dailyreport = Dailyreport.new(dailyreport_params)

    @dailyreport.issues.each do |cr_issue|
      call_jira_api("https://agenceinspire.atlassian.net/rest/api/3/issue/#{cr_issue.jiraid}")
      if @response_output_issues.key?('errors')
        flash.alert = "Please check if #{cr_issue.jiraid} exists and is available on JIRA"
        no_api_reponse
      else
        issue_details_from_jira(cr_issue)
        issue_time_real_from_jira(cr_issue)
      end
      if @dailyreport.save!
        redirect_to @dailyreport, notice: 'Dailyreport was successfully created.'
      else
        render :new
      end
    end
  end

  def update
    if @dailyreport.update(dailyreport_params)
      redirect_to @dailyreport, notice: 'Dailyreport was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    if current_user.admin? || current_user.email == @dailyreport.owner.email
      @dailyreport.destroy
    else
      admin_only_access
    end
    previous_page
  end

  private

  def dailyreport_params
    params.require(:dailyreport).permit(
      :comment,
      :owner_id,
      issues_attributes: [
        :jiraid,
        :project_id,
        :owner_id,
        :time_forecast,
        :time_real,
        :issue_type,
        :retour_test,
        :status,
        :_destroy
      ]
    )
  end

  def define_dailyreport
    @dailyreport = Dailyreport.find(params[:id])
  end
end
