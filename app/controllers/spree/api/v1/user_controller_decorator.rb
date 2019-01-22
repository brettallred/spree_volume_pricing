module Spree
  module Api
    module V1
      class UsersController < Spree::Api::BaseController

      	def index
          @users = Spree.user_class.accessible_by(current_ability, :read)

          # Customization: Filter users who has already assigned to pricing tier for same supplier
          if params[:supplier_id].present?
            supplier = Spree::Supplier.find_by(id: params[:supplier_id])
            params[:q][:id_not_in] = supplier.pricing_tiers.select('spree_users.id AS user_id').joins(:users).map(&:user_id)
          end

          @users = if params[:ids]
                     @users.ransack(id_in: params[:ids].split(','))
                   else
                     @users.ransack(params[:q])
                   end

          @users = @users.result.page(params[:page]).per(params[:per_page])

          expires_in 15.minutes, public: true
          headers['Surrogate-Control'] = "max-age=#{15.minutes}"
          respond_with(@users)
        end

      end
    end
  end
end
