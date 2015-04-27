class NoDefaultBackend < I18n::Backend::Simple
  def lookup(locale, key, scope = [], options = {})
    options.delete_if { |key, value| key == :default && default_string?(value) }
    if options.key?(:default) && options[:default].is_a?(Array)
      options[:default].reject! { |item| default_string?(item) }
    end
    super
  end

  private

  def default_string?(value)
    value.is_a?(String) && !value.blank? && value.exclude?('translation missing')
  end
end

I18n.config.backend = NoDefaultBackend.new
