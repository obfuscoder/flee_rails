module ApplicationHelper
  def flash_class_from_type type
    map = { notice: 'success', alert: 'danger', flash: 'warning' }
    "flash bg-#{map[type.to_sym]}"
  end
end
