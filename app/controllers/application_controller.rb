class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  #未ログイン時にはログインページに遷移
  before_action :authenticate_user!
  #もしdevise_controllerが呼ばれたら、追加のパラメーターを許可するメソッドを呼び出す
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected
  #追加のパラメーターを許可するメソッドを定義
  def configure_permitted_parameters
    #サインアップ時にnameカラムをパラメーターとして渡すように設定
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end
end
