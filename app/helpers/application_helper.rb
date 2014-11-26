module ApplicationHelper

  def name_helper
    controller_name.humanize
  end

  def error_messages_for(object)
    render(:partial => 'application/error_messages', :locals => {:object => object})
  end

  def flash_class_name(name)
    case name
    when 'notice' then 'info'
    when 'alert'  then 'danger'
    else name
    end
  end

end
