class Merchant::DiscountsController < Merchant::BaseController
  def index
    @merchant = Merchant.find(current_user.merchant_id)
    @discounts = @merchant.discounts.all if current_merchant_user?
  end

  def show
    @discount = Discount.find(params[:id])
  end
end
