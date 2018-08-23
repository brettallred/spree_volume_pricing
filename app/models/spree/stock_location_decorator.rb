Spree::StockLocation.class_eval do
  has_one :supplier, dependent: :destroy
end
