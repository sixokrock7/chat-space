class Message < ApplicationRecord
  #groupsモデルとのアソシエーションを定義
  belongs_to :group
  #usersモデルとのアソシエーションを定義
  belongs_to :user
  #contentカラムのバリデーションを設定
  validates :content, presence: true, unless: :image?

  mount_uploader :image, ImageUpoader
end
