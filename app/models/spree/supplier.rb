class Spree::Supplier < ActiveRecord::Base
  has_many :volume_prices, -> { order(position: :asc) }, dependent: :destroy
  belongs_to :stock_location, dependent: :destroy
  validates :name, presence: true, uniqueness: true

  after_initialize :create_supplier

  private

  def create_supplier
    self.stock_location = Spree::StockLocation.new(name: name)
  end
end
