class AddBooktoReview < ActiveRecord::Migration[6.1]
  def change
    add_reference :reviews, :book_id, null: false, foreign_key: true
  end
end
