class CreateLeadStatusHistories < ActiveRecord::Migration[8.1]
  def change
    create_table :lead_status_histories do |t|
      t.references :lead, null: false, foreign_key: true
      t.references :changed_by, null: false, foreign_key: { to_table: :users }
      t.integer :previous_status
      t.integer :new_status, null: false
      t.text :description
      t.datetime :changed_at, null: false

      t.timestamps
    end

    add_index :lead_status_histories, [ :lead_id, :changed_at ]
    add_index :lead_status_histories, :new_status
    add_index :lead_status_histories, :changed_at
  end
end
