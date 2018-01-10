class AccountController < ApplicationController
  before_action :require_user
  before_action :get_cart_items
  before_action :load_base_cateogries
  add_breadcrumb I18n.t("product.home"), :root_path

  def index
    add_breadcrumb t("account.overview"), :account_path
  end

  def edit
    add_breadcrumb t("account.overview"), :account_path
    add_breadcrumb t("account.edit"), :account_edit_path
  end

  def orders
    add_breadcrumb t('account.order'), :account_orders_path
  end
end
