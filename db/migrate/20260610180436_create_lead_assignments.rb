class CreateLeadAssignments < ActiveRecord::Migration[8.1]
  def change
    create_table :lead_assignments do |t|
      t.references :lead, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.references :assigned_by, null: true, foreign_key: { to_table: :users }
      t.integer :position, null: false, default: 0
      t.boolean :active, null: false, default: true
      t.datetime :assigned_at, null: false

      t.timestamps
    end

    add_index :lead_assignments, [ :lead_id, :user_id ], unique: true, where: "active = true"
    add_index :lead_assignments, [ :user_id, :active ]
    add_index :lead_assignments, [ :user_id, :position ]
    add_index :lead_assignments, :assigned_at
  end
end
