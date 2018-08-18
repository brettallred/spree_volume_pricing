class AddSupplierToVolumePrice < ActiveRecord::Migration[5.2]
  def change
    add_column :spree_volume_prices, :user_id, :integer, index: true
    add_column :spree_volume_prices, :supplier_id, :integer, index: true
  end
end
