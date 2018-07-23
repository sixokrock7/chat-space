class MessagesController < ApplicationController
  #before_actionでset_groupを呼び出すことで全てのアクションを行う前に@groupを利用できるように設定
  before_action :set_group
  def index
    #Messageモデルの新しいインスタンスを生成
    @message = Message.new
    #usersモデルの値も同時に取得することでN+1問題を解消してgroupに所属している全てのメッセージを取得してインスタンス変数へ格納
    @messages = group.messages.includes(:user)
  end

  def create
    #ストロングパラメーターで設定した値を取得してGroupsテーブルのmessageカラムの値を保存してインスタンス変数に格納
    @message = @group.messages.new(message_params)
    #もし値が保存出来たら、
    if @message.save

      respond_to do |format|
        format.html { redirect_to group_messages_path(params[:group_id]) }
      format.json
      #redirect_to group_messages_path(@group), notice: 'メッセージが送信されました'
    else
      @messages = @group.messages.includes(:user)
      flash.now[:alert] = 'メッセージを入力してください'
      render:index
  end

  private

  def message_params
    params.require(:message).permit(:content, :image).merge(user_id: current_user.id)
  end
  #group_idキーで送られてきたパラメーターの値をgroupsテーブルから取得してインスタンス変数へ格納するメソッドを定義
  def set_group
    @group = Group.find(params[:group_id])
  end
end
