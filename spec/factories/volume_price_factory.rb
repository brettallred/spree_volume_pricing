FactoryBot.define do
  factory :volume_price, class: Spree::VolumePrice do
    amount 10
    discount_type 'price'
    range '(1..5)'
    association :variant
    association :pricing_tier
    after(:create) { |volume_price| volume_price.supplier_id = volume_price.pricing_tier.supplier_id; volume_price.save }
  end

  factory :volume_price_model, class: Spree::VolumePriceModel do
    name 'name'
  end
end