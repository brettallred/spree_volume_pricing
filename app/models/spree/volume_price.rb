class Spree::VolumePrice < ActiveRecord::Base
  if Gem.loaded_specs['spree_core'].version >= Gem::Version.create('3.3.0')
    belongs_to :variant, touch: true, optional: true
    belongs_to :volume_price_model, touch: true, optional: true
    belongs_to :spree_role, class_name: 'Spree::Role', foreign_key: 'role_id', optional: true
    belongs_to :supplier, touch: true, optional: true
    belongs_to :user, touch: true, optional: true
    belongs_to :pricing_tier
  else
    belongs_to :variant, touch: true
    belongs_to :volume_price_model, touch: true
    belongs_to :spree_role, class_name: 'Spree::Role', foreign_key: 'role_id'
  end

  acts_as_list scope: [:variant_id, :volume_price_model_id]

  validates :amount, presence: true
  validates :discount_type,
            presence: true,
            inclusion: {
              in: %w(price dollar percent),
              message: 'is not valid volume price type'
            }
  validates :range,
            format: {
              with: /\(?[0-9]+(?:\.{2,3}[0-9]+|\+\)?)/,
              message: 'must be in one of the following formats: (a..b), (a...b), (a+). Here are following examples: 1..3 , 1...5 , 5+'
            }

  OPEN_ENDED = /\(?[0-9]+\+\)?/

  def include?(quantity)
    if open_ended?
      bound = /\d+/.match(range)[0].to_i
      return quantity >= bound
    else
      range.to_range === quantity
    end
  end

  def calculated_price
    @calculated_price ||= begin
                        case discount_type
                        when 'price'
                          return amount
                        when 'dollar'
                          return variant.price - amount
                        when 'percent'
                          return variant.price * (1 - amount)
                        end
                      end
  end

  # indicates whether or not the range is a true Ruby range or an open ended range with no upper bound
  def open_ended?
    OPEN_ENDED =~ range
  end
end
