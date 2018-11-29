class AddFieldPricingTierIdToVolumePricing < ActiveRecord::Migration[5.2]
  def change
    add_column :spree_volume_prices, :pricing_tier_id, :integer
  end
end
