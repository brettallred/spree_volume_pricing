Spree::BaseHelper.class_eval do
  def display_volume_price(variant, quantity = 1, user = nil)
    Spree::Money.new(
      variant.volume_price(quantity, user),
      currency: Spree::Config[:currency]
    ).to_html
  end

  def display_volume_price_earning_percent(variant, quantity = 1, user = nil)
    variant.volume_price_earning_percent(quantity, user).round.to_s
  end

  def display_volume_price_earning_amount(variant, quantity = 1, user = nil)
    Spree::Money.new(
      variant.volume_price_earning_amount(quantity, user),
      currency: Spree::Config[:currency]
    ).to_html
  end

  # renders hidden field and link to remove volume price using nested_attributes
  def link_to_icon_remove_volume_price(f)
    url = f.object.persisted? ? [:admin, f.object] : '#'
    link_to_with_icon('delete', '', url, class: 'spree_remove_volume_price btn btn-sm btn-danger', data: { action: 'remove' }, title: Spree.t(:remove)) + f.hidden_field(:_destroy)
  end
end
