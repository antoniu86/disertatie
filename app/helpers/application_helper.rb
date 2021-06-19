module ApplicationHelper
  def icon(class_name, options = {})
    "<i class=\"#{class_name}\"></i>".html_safe
  end
end
