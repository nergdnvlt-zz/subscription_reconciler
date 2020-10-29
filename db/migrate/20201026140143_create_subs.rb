class CreateSubs < ActiveRecord::Migration[6.0]
  def change
    create_table :subs do |t|
      t.string :xsolla_id
      t.string :fs_id
      t.string :import_id
      t.boolean :active
      t.string :state
      t.string :term
      t.date :next_charge_date
      t.string :product
      t.string :product_display
      t.string :account_id

      t.timestamps
    end
  end
end
