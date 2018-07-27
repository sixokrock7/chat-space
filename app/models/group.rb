class Group < ApplicationRecord
  has_many :group_users
  has_many :users, through: :group_users
  has_many :messages
  validates :name, presence: true

  def show_last_message
    #最新のメッセージを変数last_messageに代入しつつ、メッセージが投稿されているかどうかで処理を分ける
    if (last_message == messages.last).present?
      #文章が投稿されている場合、さらに画像が投稿されているかで処理を分ける（三項演算子で記述）
      last_message_content? ? last_message.content : '画像が投稿されています'
    else
      'まだメッセージはありません'
    end
  end
end
