class Issue < ApplicationRecord
  max_paginates_per 10

	before_create { |issue| issue.jiraid = issue.jiraid.upcase }


	validates :jiraid, uniqueness: true

	validates :jiraid, :project, :owner, :departement, :time_forecast, :time_real, presence: true
  validates :jiraid, format: { with: /\b[a-zA-Z]{2,4}-[1-9]\d{0,3}\b/, message: "must follow this format ABCXYZ-9999" }
  before_validation :check_project_exists
  before_validation :check_jiraid_project_match

	validates :time_real, numericality: { only_float: true }
	validates :time_forecast, numericality: { only_float: true }


  def check_project_exists
    first_part = jiraid.upcase.match(/\b[a-zA-Z]{2,4}/)[0]
    unless Project.exists?(jiraid: first_part)
      errors.add(:jiraid, "does not belong to a valid project")
    end
  end

  def check_jiraid_project_match
    first_part = jiraid.upcase.match(/\b[a-zA-Z]{2,4}/)[0]
    project_jiraid = Project.find_by(name: project).jiraid
    unless first_part == project_jiraid
      errors.add(:jiraid, "should be in this format #{project_jiraid}-9999")
    end
  end

end
