class AddVolumePricingIdToLineItems < ActiveRecord::Migration[5.2]
  def change
    add_column :spree_line_items, :volume_price_id, :integer, index: true, null: true
  end
end
