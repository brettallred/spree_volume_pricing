class Spree::Supplier < ActiveRecord::Base
  has_many :volume_prices, -> { order(position: :asc) }, dependent: :destroy
  validates :name, presence: true, uniqueness: true
end
