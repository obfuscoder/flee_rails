# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CreateLabelsDocumentJob do
  subject(:action) { described_class.perform_now event }

  let(:event) { double :event, id: 123, client: client, items: double(includes: items) }
  let(:client) { double :client }
  let(:items) { double :items }
  let(:delete_service) { double call: nil }
  let(:create_service) { double call: pdf }
  let(:file) { double write: nil }
  let(:mail) { double deliver_now: nil }
  let(:delete_job) { double perform_later: nil }
  let(:pdf) { double }

  before do
    allow(DeleteLabelDocumentFiles).to receive(:new).and_return(delete_service)
    allow(DeleteLabelsDocumentJob).to receive(:set).and_return(delete_job)
    allow(CreateLabelDocument).to receive(:new).and_return(create_service)
    allow(FileUtils).to receive(:mkdir_p)
    allow(File).to receive(:open).and_yield(file)
    allow(NotificationMailer).to receive(:label_document_created).and_return(mail)
    Timecop.freeze(Time.local(2019, 12, 7, 20, 14, 15)) { action }
  end

  it 'calls the delete service' do
    expect(DeleteLabelDocumentFiles).to have_received(:new).with(event)
    expect(delete_service).to have_received(:call)
  end

  it 'ensures existence of document file path' do
    expect(FileUtils).to have_received(:mkdir_p).with('public/download/labels')
  end

  it 'stores pdf document in download folder' do
    expect(File).to have_received(:open).with(Rails.root.join('public/download/labels/123_20191207201415.pdf'), 'wb')
    expect(file).to have_received(:write).with(pdf)
  end

  it 'creates label document' do
    expect(CreateLabelDocument).to have_received(:new).with(client, items)
    expect(create_service).to have_received(:call)
  end

  it 'schedules the delete job' do
    expect(DeleteLabelsDocumentJob).to have_received(:set).with(wait: 2.weeks)
    expect(delete_job).to have_received(:perform_later)
  end

  it 'notifies about created document' do
    expect(NotificationMailer).to have_received(:label_document_created)
      .with(event, 'https://flohmarkthelfer.de/download/labels/123_20191207201415.pdf')
    expect(mail).to have_received(:deliver_now)
  end
end
