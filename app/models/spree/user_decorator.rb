Spree.user_class.class_eval do
  has_and_belongs_to_many :pricing_tiers

  def resolve_role
    if self.has_spree_role? Spree::Config.volume_pricing_role.to_sym
      return Spree::Role.find_by name: Spree::Config.volume_pricing_role
    else
      return Spree::Role.find_by name: 'user'
    end
  end
end
