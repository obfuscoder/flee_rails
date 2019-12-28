class CreateLabelsDocumentJob < ApplicationJob
  queue_as :default

  def perform(event)
    delete_existing_label_files(event)
    download_url = create_label_file(event)
    NotificationMailer.label_document_created(event, download_url).deliver_now
    DeleteLabelsDocumentJob.set(wait: 2.weeks).perform_later(event)
  end

  private

  def delete_existing_label_files(event)
    DeleteLabelDocumentFiles.new(event).call
  end

  def create_label_file(event)
    pdf = CreateLabelDocument.new(event.client, event.items.includes(:category, :reservation)).call
    time_part = Time.now.strftime '%Y%m%d%H%M%S'
    file_name = "#{event.id}_#{time_part}.pdf"
    path = 'public/download/labels'
    FileUtils.mkdir_p(path)
    file_path = Rails.root.join("#{path}/#{file_name}")
    File.open(file_path, 'wb') { |f| f.write pdf }
    "https://flohmarkthelfer.de/download/labels/#{file_name}"
  end
end
