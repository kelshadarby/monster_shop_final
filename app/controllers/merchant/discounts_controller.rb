class Merchant::DiscountsController < Merchant::BaseController
  def index
    @merchant = Merchant.find(current_user.merchant_id)
    @discounts = @merchant.discounts.all if current_merchant_user?
  end

  def show
    @discount = Discount.find(params[:id])
  end

  def new
  end

  def create
    merchant = Merchant.find(current_user.merchant_id)
    discount = merchant.discounts.new(discount_params)

    if discount.save
      flash[:success] = "Your bulk discount has been created!"
      redirect_to merchant_discounts_path
    else
      flash.now[:error] = discount.errors.full_messages.to_sentence
      render :new
    end
  end

  private

  def discount_params
    params.permit(:percent_off, :min_quantity)
  end

end
