class CreateRevenueRanges < ActiveRecord::Migration[8.1]
  def change
    create_table :revenue_ranges do |t|
      t.string :name, null: false
      t.string :code, null: false
      t.integer :position, null: false, default: 0
      t.decimal :min_value, precision: 15, scale: 2
      t.decimal :max_value, precision: 15, scale: 2

      t.timestamps
    end

    add_index :revenue_ranges, :code, unique: true
    add_index :revenue_ranges, :position
  end
end
