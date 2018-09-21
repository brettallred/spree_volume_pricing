class Spree::Supplier < ActiveRecord::Base
  has_many :volume_prices, -> { order(position: :asc) }, dependent: :destroy
  belongs_to :stock_location, dependent: :destroy
  has_one_attached :logo
  validates :name, presence: true, uniqueness: true

  before_validation :create_stock_location
  before_save :ensure_stock_location_name_matches

  private

  def create_stock_location
    if stock_location.nil?
      self.stock_location = Spree::StockLocation.new(name: name)
    end
  end

  def ensure_stock_location_name_matches
    self.stock_location.name = self.name
  end

end
