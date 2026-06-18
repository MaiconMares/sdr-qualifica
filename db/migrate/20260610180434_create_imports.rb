class CreateImports < ActiveRecord::Migration[8.1]
  def change
    create_table :imports do |t|
      t.references :user, null: false, foreign_key: true
      t.string :filename, null: false
      t.string :content_type
      t.integer :status, null: false, default: 0
      t.integer :total_rows, default: 0
      t.integer :processed_rows, default: 0
      t.integer :imported_rows, default: 0
      t.integer :skipped_rows, default: 0
      t.integer :failed_rows, default: 0
      t.text :error_message
      t.jsonb :errors_detail, default: []
      t.datetime :started_at
      t.datetime :finished_at

      t.timestamps
    end

    add_index :imports, :status
    add_index :imports, :created_at
  end
end
