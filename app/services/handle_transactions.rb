# frozen_string_literal: true

class HandleTransactions
  def initialize(event)
    @event = event
  end

  def call(transactions)
    ActiveRecord::Base.transaction do
      transactions.each { |transaction| handle_transaction(transaction) }
    end
  end

  private

  def handle_transaction(transaction_data)
    return if @event.transactions.find_by(number: transaction_data['id']).present?
    ActiveRecord::Base.transaction do
      begin
        transaction = @event.transactions.create! number: transaction_data['id'],
                                                  created_at: Time.zone.parse(transaction_data['date']),
                                                  kind: transaction_data['type'].downcase,
                                                  zip_code: transaction_data['zip_code']
        transaction_data['items'].each { |code| fetch_and_handle_item(transaction, code) }
      rescue ActiveRecord::ActiveRecordError, ArgumentError => ex
        Rails.logger.error ex.message
        Rails.logger.error ex.backtrace.join("\n")
      end
    end
  end

  def fetch_and_handle_item(transaction, code)
    item = @event.items.find_by code: code
    if item.present?
      handle_item(transaction, item)
    else
      stock_item = @event.client.stock_items.find_by code: code
      handle_stock_item(transaction, stock_item) if stock_item.present?
    end
  end

  def handle_item(transaction, item)
    item.sold = transaction.created_at if transaction.purchase?
    item.sold = nil if transaction.refund?
    item.save! context: :transaction
    transaction.transaction_items.create! item: item, created_at: transaction.created_at
  end

  def handle_stock_item(transaction, stock_item)
    sold_stock_item = stock_item.sold_stock_items.find_or_create_by event: @event
    sold_stock_item.amount += 1 if transaction.purchase?
    sold_stock_item.amount -= 1 if transaction.refund? && sold_stock_item.sold.positive?
    sold_stock_item.save! context: :transaction
    create_or_update_transaction_stock_item(stock_item, transaction)
  end

  def create_or_update_transaction_stock_item(stock_item, transaction)
    transaction_stock_item = transaction.transaction_stock_items.find_by(stock_item: stock_item) ||
                             transaction.transaction_stock_items.build(stock_item: stock_item,
                                                                       created_at: transaction.created_at,
                                                                       amount: 0)
    transaction_stock_item.amount += 1
    transaction_stock_item.save!
  end
end
