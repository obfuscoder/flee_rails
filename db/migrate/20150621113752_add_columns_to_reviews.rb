class AddColumnsToReviews < ActiveRecord::Migration
  def change
    add_column :reviews, :registration, :integer
    add_column :reviews, :items, :integer
    add_column :reviews, :print, :integer
    add_column :reviews, :reservation, :integer
    add_column :reviews, :mailing, :integer
    add_column :reviews, :content, :integer
    add_column :reviews, :design, :integer
    add_column :reviews, :support, :integer
    add_column :reviews, :handover, :integer
    add_column :reviews, :payoff, :integer
    add_column :reviews, :sale, :integer
    add_column :reviews, :organization, :integer
    add_column :reviews, :total, :integer
    add_column :reviews, :source, :string
    add_column :reviews, :recommend, :boolean
    add_column :reviews, :to_improve, :text
  end
end
