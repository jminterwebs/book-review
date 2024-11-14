class CreateReviews < ActiveRecord::Migration[6.1]
  def change
    create_table :reviews do |t|
      t.string :content
      t.decimal :rating, precision: 3, scale: 2
      t.timestamps
    end
  end
end
