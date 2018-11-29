class CreatePricingTiersUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :spree_pricing_tiers_users do |t|
      t.belongs_to :pricing_tier, index: true
      t.belongs_to :user, index: true
    end
  end
end
