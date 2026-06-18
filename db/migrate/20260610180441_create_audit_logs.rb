class CreateAuditLogs < ActiveRecord::Migration[8.1]
  def change
    create_table :audit_logs do |t|
      t.references :user, null: true, foreign_key: true
      t.integer :action, null: false
      t.string :auditable_type
      t.bigint :auditable_id
      t.jsonb :metadata, default: {}
      t.string :ip_address
      t.string :user_agent
      t.datetime :occurred_at, null: false

      t.timestamps
    end

    add_index :audit_logs, :action
    add_index :audit_logs, [ :auditable_type, :auditable_id ]
    add_index :audit_logs, :occurred_at
    add_index :audit_logs, [ :user_id, :occurred_at ]
  end
end
