module DailyreportsHelper
  def status_icon(status)
    case status
    when "Done"
      "<i class='bi bi-check-all'></i>".html_safe
    when "Archived"
      "<i class='bi bi-archive'></i>".html_safe
    when 'In Progress'
      "<i class='bi bi-gear-wide-connected'></i>".html_safe
    when "On Hold"
      "<i class='bi bi-hourglass'></i>".html_safe
    else
      "<i class='bi bi-question'></i>".html_safe
    end
  end
end
