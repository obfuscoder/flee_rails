module PagesHelper
  def logos
    Dir["app/assets/images/#{brand_key}/logo/*"].map { |path| "#{brand_key}/logo/#{File.basename(path)}" }
  end
end
