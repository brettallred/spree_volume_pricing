Spree::LineItem.class_eval do
  belongs_to :volume_price, class_name: 'Spree::VolumePrice'
  
  # pattern grabbed from: http://stackoverflow.com/questions/4470108/

  # the idea here is compatibility with spree_sale_products
  # trying to create a 'calculation stack' wherein the best valid price is
  # chosen for the product. This is mainly for compatibility with spree_sale_products
  #
  # Assumption here is that the volume price currency is the same as the product currency
  old_copy_price = instance_method(:copy_price)
  define_method(:copy_price) do
    old_copy_price.bind(self).call
    return unless variant

    if changed? && changes.keys.include?('quantity')
      amount, volume_price = self.variant.volume_price_and_amount(self.quantity, self.order.user)
      self.volume_price_id = volume_price&.id
      self.price = amount and return
    end

    self.price = variant.price if price.nil?
  end

  # Used this pattern for backward compatibility
  old_update_price = instance_method(:update_price)
  define_method(:update_price) do
    amount, volume_price = self.variant.volume_price_and_amount(self.quantity, self.order.user)
    self.price = amount
    self.volume_price_id = volume_price&.id
  end
end