# frozen_string_literal: true

class MessageGenerator
  def initialize(data = {})
    @data_extractor = DataExtractor.new(data)
  end

  def generate(template_message)
    OpenStruct.new subject: replace(template_message.subject), body: replace(template_message.body)
  end

  private

  def replace(template)
    template.gsub(/{{.*?}}/) { |place_holder| evaluate(place_holder) }
  end

  def evaluate(place_holder)
    @data_extractor.send place_holder.delete('{{').delete('}}').strip
  end
end
