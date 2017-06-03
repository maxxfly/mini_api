class CreateTransfers < ActiveRecord::Migration[5.1]
  def change
    create_table :transfers do |t|
      t.integer :user_id, null: false
      t.string :account_number_from, null: false
      t.string :account_number_to, null: false
      t.column :amount_pennies, 'integer unsigned'
      t.string :country_code_from, null: false
      t.string :country_code_to, null: false
    end
  end
end
