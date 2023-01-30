class IssueTypesController < ApplicationController
  before_action :admin_only_access

  def index
    @issue_types = IssueType.all.order(created_at: :desc)
  end

  def new
    @issue_type = IssueType.new
  end

  def create
    @issue_type = IssueType.new(issue_type_params)
    if @issue_type.save
      redirect_to issue_types_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @issue_type = IssueType.find(params[:id])
  end

  def show
    @issue_type = IssueType.find(params[:id])
  end

  def update
    @issue_type = IssueType.find(params[:id])

    if @issue_type.update(issue_type_params)
      redirect_to issue_types_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @issue_type = IssueType.find(params[:id])
    @issue_type.destroy

    redirect_to issue_types_path
  end

  private

  def issue_type_params
    params.require(:issue_type).permit(:name)
  end
end
