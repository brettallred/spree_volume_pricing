module Spree
  module Admin
    class PricingTiersController < Spree::Admin::BaseController
       before_action :set_supplier
       before_action :set_pricing_tier, only: [:edit, :show, :destroy, :update]

      def index
        @pricing_tiers = @supplier.pricing_tiers.all
      end

      def new
        @pricing_tier = @supplier.pricing_tiers.build
      end

      def create
       @pricing_tier = @supplier.pricing_tiers.build(pricing_tier_params)
       if @pricing_tier.save
         flash[:success] = flash_message_for(@pricing_tier, :successfully_created)
         redirect_to admin_supplier_pricing_tiers_path(@supplier)
       else
         render :new
       end
      end

      def update
       if @pricing_tier.update_attributes(pricing_tier_params)
         flash[:success] = Spree.t(:successfully_updated, resource: Spree.t(:pricing_tier))
         redirect_to admin_supplier_pricing_tiers_path(@supplier)
       else
         render :edit
       end
      end

      def destroy
       if @pricing_tier.destroy
         flash[:success] = Spree.t(:successfully_removed, resource: Spree.t(:pricing_tier))
       end
       redirect_to admin_supplier_pricing_tiers_path(@supplier)
      end

      private

      def set_supplier
        @supplier = Spree::Supplier.find_by(id: params[:supplier_id])
      end

      def set_pricing_tier
         @pricing_tier = @supplier.pricing_tiers.find_by(id: params[:id])
      end

      def pricing_tier_params
         params.require(:pricing_tier).permit(:name)
      end
    end
  end
end