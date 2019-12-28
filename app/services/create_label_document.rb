class CreateLabelDocument
  def initialize(client, items)
    @client = client
    @items = items
  end

  def call
    @items.select { |item| item.code.nil? }.each do |item|
      item.create_code prefix: @client.prefix
      item.save! context: :generate_label
    end
    LabelDocument.new(label_decorators).render
  end

  private

  def label_decorators
    @items.map { |item| LabelDecorator.new item }
  end
end
