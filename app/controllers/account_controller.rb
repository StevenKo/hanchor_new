class AccountController < ApplicationController
  before_action :require_user
  before_action :get_cart_items
  before_action :load_base_cateogries
  add_breadcrumb "首頁", :root_path

  def index
    add_breadcrumb "帳號總覽", :account_path
  end

  def edit
    add_breadcrumb "帳號總覽", :account_path
    add_breadcrumb "修改資料", :account_edit_path
  end

  def orders
    add_breadcrumb t('account.order'), :account_orders_path
  end
end
