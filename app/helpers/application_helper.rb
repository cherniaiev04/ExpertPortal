module ApplicationHelper
  def flash_class(level)
    case level.to_sym
    when :notice then 'alert-success'  # For successful operations
    when :alert then 'alert-warning'   # For warnings
    when :error then 'alert-danger'    # For errors
    else 'alert-info'                  # For general messages
    end
  end
end
