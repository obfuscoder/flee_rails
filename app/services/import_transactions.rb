class ImportTransactions
  def initialize(event)
    @event = event
  end

  def call(transactions)
    transactions.each { |transaction| ImportTransactionJob.perform_later @event, transaction }
    transactions.count
  end
end
