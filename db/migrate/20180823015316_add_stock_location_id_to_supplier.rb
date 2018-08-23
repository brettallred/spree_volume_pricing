class AddStockLocationIdToSupplier < ActiveRecord::Migration[5.2]
  def change
    add_column :spree_suppliers, :stock_location_id, :integer
    add_index :spree_suppliers, :stock_location_id
  end
end
