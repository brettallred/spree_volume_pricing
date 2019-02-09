RSpec.describe Spree::LineItem, type: :model do
  before do
    @order = create(:order)
    @variant = create(:variant, price: 10)
    @volume_price = create(:volume_price, amount: 9, range: '5+')
    @variant.volume_prices << @volume_price
  end

  it 'should updates the price with respect to quantity' do
    @order.contents.add(@variant, 1)
    @line_item = @order.line_items.first
    expect(@line_item.price.to_f).to be(10.00)
    @order.contents.add(@variant, 6)
    @line_item.update_price
    expect(@order.line_items.first.price.to_f).to be(9.00)
  end

  it 'should set correct volume price id' do
    @order.contents.add(@variant, 1)
    @line_item = @order.line_items.first
    expect(@line_item.volume_price_id).to be nil
    @order.contents.add(@variant, 6)
    @line_item.update_price
    expect(@line_item.volume_price_id).to be @volume_price.id
  end
end