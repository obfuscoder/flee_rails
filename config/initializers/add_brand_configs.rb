Dir.glob "#{Rails.root}/config/settings/brands/*.yml" do |file_path|
  Settings.add_source! file_path
end
Settings.reload!
