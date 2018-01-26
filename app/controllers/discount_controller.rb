class DiscountController < ApplicationController
  
  def apply
    discount_rule = DiscountRule.find_by(code: params[:code])
    if discount_rule
      redirect_to cart_index_path(code: params[:code])
    else
      redirect_to cart_index_path
    end
  end

end
