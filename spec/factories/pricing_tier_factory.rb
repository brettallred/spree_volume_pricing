FactoryBot.define do
  factory :pricing_tier, class: Spree::PricingTier do
    name { FFaker::Name.name }
    association :supplier, factory: :supplier
    available_to_all_users true
  end
end