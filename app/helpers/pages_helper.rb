module PagesHelper
  def logos
    [brand_settings.home.try(:logo)].compact.flatten
  end
end
