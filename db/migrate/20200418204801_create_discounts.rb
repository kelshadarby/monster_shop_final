class CreateDiscounts < ActiveRecord::Migration[5.1]
  def change
    create_table :discounts do |t|
      t.integer :percent_off
      t.integer :min_quantity
    end
  end
end
