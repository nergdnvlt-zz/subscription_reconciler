class CreateEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :events do |t|
      t.string :fs_id
      t.string :fs_type
      t.jsonb :data

      t.timestamps
    end
  end
end
