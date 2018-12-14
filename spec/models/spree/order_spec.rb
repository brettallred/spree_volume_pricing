RSpec.describe Spree::Order, type: :model do
  before do
    @order = create(:order)
    @variant = create(:variant, price: 10)

    @variant_with_prices = create(:variant, price: 10)
    @volume_price1 = create(:volume_price, range: '1..5', amount: 9, position: 2)
    @volume_price2 = create(:volume_price, range: '(5..9)', amount: 8, position: 1)
    @variant_with_prices.volume_prices << @volume_price1
    @variant_with_prices.volume_prices << @volume_price2
  end

  context 'add_variant' do
    it 'uses the variant price if there are no volume prices' do
      @order.contents.add(@variant)
      expect(@order.line_items.first.price).to eq(10)
    end

    it 'uses the volume price if volume price is assigned to line item' do
      options = { volume_price_id: @volume_price1.id }
      @order.contents.add(@variant_with_prices, 7, options)
      expect(@order.line_items.first.price).to eq(9)
      @line_item = @order.line_items.first
      @line_item.update_attributes(volume_price_id: nil)
      @line_item.update_price
      expect(@order.line_items.first.price).to eq(10)
    end

    xit 'uses the variant price if the quantity fails to satisfy any of the volume price ranges' do
      @order.contents.add(@variant, 10)
      expect(@order.line_items.first.price).to eq(10)
    end

    xit 'uses the first matching volume price in the event of more then one matching volume prices' do
      @order.contents.add(@variant_with_prices, 5)
      expect(@order.line_items.first.price).to eq(8)
    end

    it 'uses the master variant volume price in case variant has no volume price if config is true' do
      Spree::Config.use_master_variant_volume_pricing = true
      @master = @variant.product.master
      options = { volume_price_id: @volume_price1.id }
      @master.volume_prices << @volume_price1
      @order.contents.add(@variant, 5, options)
      expect(@order.line_items.first.price).to eq(9)
    end

    it 'doesnt use the master variant volume price in case variant has no volume price if config is false' do
      Spree::Config.use_master_variant_volume_pricing = false
      @master = @variant.product.master
      @master.volume_prices << create(:volume_price, range: '(1..5)', amount: 9, position: 2)
      @order.contents.add(@variant, 5)
      expect(@order.line_items.first.price).to eq(10)
    end
  end
end
