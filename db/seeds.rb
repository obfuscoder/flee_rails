# frozen_string_literal: true

%w[client stock_message_template hardware].each do |entity|
  file = Rails.root.join 'db', 'seeds', "#{entity.pluralize}.yml"
  yaml = YAML.load_file file
  entity.camelize.constantize.create! yaml
end
