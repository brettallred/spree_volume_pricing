class CreateSpreePricingTiers < ActiveRecord::Migration[5.2]
  def change
    create_table :spree_pricing_tiers do |t|
      t.references :supplier
      t.string :name

      t.timestamps
    end
  end
end
