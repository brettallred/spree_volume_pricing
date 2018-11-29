class Spree::PricingTier < ApplicationRecord
  belongs_to :supplier
  has_and_belongs_to_many :users
  has_many :volume_prices, -> { order(position: :asc) }, dependent: :destroy
end
