class AddFieldsToPricingTier < ActiveRecord::Migration[5.2]
  def change
    add_column :spree_pricing_tiers, :available_to_all_users, :boolean, default: false
  end
end
