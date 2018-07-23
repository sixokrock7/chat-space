class UsersController < ApplicationController
  def edit
  end

  def update
    #もしログイン中のユーザーのテーブルの値が更新されたら
    if current_user.update(user_params)
      #トップページへリダイレクト
      redirect_to root_path
    else
      #editのビューを再描画
      render :edit
    end
  end

  private

  def user_params
    #userテーブルに制限して、nameカラムとemailカラムの値をパラメーターとして渡す
    params.require(:user).permit(:name, :email)
  end
end
