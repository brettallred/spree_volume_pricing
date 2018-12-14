RSpec.describe Spree::LineItem, type: :model do
  before do
    @order = create(:order)
    @variant = create(:variant, price: 10)
    @volume_price = create(:volume_price, amount: 9)
    @variant.volume_prices << @volume_price
  end

  it 'updates the line item price when the volume price is assigned' do
    @order.contents.add(@variant, 1)
    @line_item = @order.line_items.first
    expect(@line_item.price.to_f).to be(10.00)
    @line_item.update_attributes(volume_price_id: @variant.volume_prices.first.id)
    @line_item.update_price
    expect(@order.line_items.first.price.to_f).to be(9.00)
  end

  it 'should set line item price equal to selected volume price' do
    options = { volume_price_id: @volume_price.id }
    @order.contents.add(@variant, 1, options)
    expect(@order.line_items.first.price.to_f).to eq(9.00)
  end
end
