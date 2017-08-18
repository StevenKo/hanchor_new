class SessionsController < ApplicationController
  layout 'session'
  def new
  end

  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      update_current_shopping_cart_user(user.id)
      (params[:redirect_to_cart].present?)? redirect_to(cart_index_path) : redirect_to(root_path)
    else
      flash[:error] = "Something wrong, login fail!"
      redirect_back fallback_location: root_path
    end
  end
  
  def destroy
    session[:user_id] = nil
    flash[:notice] = "logged out"
    redirect_to root_path
  end

  def login_by_auth
    auth = request.env["omniauth.auth"]
    user = User.find_or_create_from_omniauth(auth)
    session[:user_id] = user.id
    redirect_to root_url
  end

  def set_currency
    session[:currency_id] = params[:currency_id]
    redirect_back fallback_location: root_path
  end
end
