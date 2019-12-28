class DeleteLabelDocumentFiles
  def initialize(event)
    @event = event
  end

  def call
    Dir.glob("public/download/labels/#{@event.id}_*.pdf").each { |file| File.delete file }
  end
end
