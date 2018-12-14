FactoryBot.define do
  factory :supplier, class: Spree::Supplier do
    name { FFaker::Name.name }
  end
end