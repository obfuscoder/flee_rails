# frozen_string_literal: true

class DeleteLabelsDocumentJob < ApplicationJob
  queue_as :default

  def perform(event)
    DeleteLabelDocumentFiles.new(event).call
  end
end
