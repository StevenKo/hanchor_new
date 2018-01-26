class Admin::DiscountsController < Admin::AdminController

  def index
    @discount_rules = DiscountRule.all
  end

  def new
  	@discount_rule = DiscountRule.new
  end

  def create
  	@discount_rule = DiscountRule.new(discount_param)
    if @discount_rule.save
      @discount_rule.discount_products.delete_all
      DiscountProduct.create(params[:products][:is_select].map{|p_id| {discount_rule_id: @discount_rule.id, product_id: p_id}}) if params[:products].present?
      flash[:notice] = "Create success"      
    else
      flash[:error] = "Create fail!"
    end
    redirect_to edit_admin_discount_path(@discount_rule)
  end

  def edit
  	@discount_rule = DiscountRule.find(params[:id])
  end

  def update
  	@discount_rule = DiscountRule.find(params[:id])
    if @discount_rule.update(discount_param)
      @discount_rule.discount_products.delete_all
      DiscountProduct.create(params[:products][:is_select].map{|p_id| {discount_rule_id: @discount_rule.id, product_id: p_id}}) if params[:products].present?
      flash[:notice] = "Update success"
    else
      flash[:error] = "Update fail!"
    end
    redirect_to edit_admin_discount_path(@discount_rule)
  end

private
  def discount_param
    params.require(:discount_rule).permit(:title,:title_en,:code,:discount_type,:discount_money, :discount_percentage,:threshold,:start_date, :end_date)
  end

end
