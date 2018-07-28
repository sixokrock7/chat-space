class GroupsController < ApplicationController
  def index
  end

  def new
    #groupsテーブルのインスタンスを生成してインスタンス変数を定義
    @group = Group.new
    #現在ログイン中のユーザーを新規作成したグループに追加
    @group.users << current_user
  end

  def create
    #ストロングパラメーターで設定した値をgroupsテーブルに保存して、インスタンス変数へ格納
    @group = Group.new(group_params)
    #もしgroupsテーブルに値が保存できたら
    if @group.save
      #トップページにリダイレクトしてフラッシュメッセージを表示
      redirect_to root_path, notice: 'グループを作成しました'
    else
      #renderを用いてHTTPリクエストを送らずnew.html.hamlを表示
      render :new
    end
  end

  def edit
  end

  def update
    if @group.update(group_params)
      redirect_to group_messages_path(@group), notice: 'グループを編集しました'
    else
      #edit.html.hamlを描画
      render :edit
    end
  end

  private
  #ストロングパラメーターの設定
  def group_params
    #groupsモデルに制限してnameカラムのパラメーターを追加
    params.require(:group).permit(:name, { :user_ids => [] })
  end

  def set_group
    @group = Group.find(params[:id])
  end
end
