class AddWebhookToEvents < ActiveRecord::Migration[6.0]
  def change
    add_reference :events, :webhook, null: false, foreign_key: true
  end
end
