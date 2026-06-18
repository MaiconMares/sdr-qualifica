class CreateLeads < ActiveRecord::Migration[8.1]
  def change
    create_table :leads do |t|
      t.references :import, null: true, foreign_key: true
      t.references :revenue_range, null: true, foreign_key: true
      t.string :company_name, null: false
      t.string :contact_name
      t.string :phone
      t.string :email
      t.string :city
      t.string :state
      t.integer :status, null: false, default: 0
      t.text :notes
      t.datetime :last_interaction_at

      t.timestamps
    end

    add_index :leads, :phone
    add_index :leads, :email
    add_index :leads, :status
    add_index :leads, :company_name
    add_index :leads, :city
    add_index :leads, :state
    add_index :leads, :created_at
    add_index :leads, :last_interaction_at
    add_index :leads, [ :phone, :email ]
  end
end
