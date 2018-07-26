require 'rails_helper'

RSpec.describe Message, type: :model do
  describe '#create' do
    #contextを用いてテストを条件ごとにまとめて見やすくする
    context 'can save' do
      it 'is valid with content' do
        #buildメソッドを用いてファクトリーで定義されたデフォルトの値を上書きすることでMessageモデルのインスタンスを作成、imageカラムの値をnilにすることでメッセージがあれば保存可能に設定
        expect(build(:message, image: nil)).to be_valid
      end

      it 'is valid with image' do
        #buildメソッドを用いてファクトリーで定義されたデフォルトの値を上書きすることでMessageモデルのインスタンスを作成、contentカラムの値をnilにすることでメッセージがあれば保存可能に設定
        expect(build(:message, content: nil)).to be_valid
      end

      #buildメソッドを用いてファクトリーで定義されたデフォルトの値を上書きすることでMessageモデルのインスタンスを作成,メッセージと画像両方があれば保存可能に設定
      it 'is valid with content and image' do
        expect(build(:message, content: nil)).to_valid
      end
    end
    #メッセージも画像もないと保存出来ないように設定
    context 'can not save' do
      it 'is invalid without content and image' do
        message = build(:message, content: nil, image: nil)
        #valid?メソッドを用いて作成したインスタンスがバリデーションによって保存ができない状態かチェック
        message.valid?
        #errorsメソッドを用いてバリデーションよって保存できない場合なぜできないのかを確認
        #expectの引数に対してmessage.errors[:カラム名]と記述することでカラムが原因のエラー文が入った配列を取り出して、includeマッチャを利用してエクスペクテーションを生成
        expect(message.errors[:content]).to include('を入力してください')
      end

      it 'is invalid without group_id' do
        message = build(:message, group_id: nil)
        message.valid?
        expect(message.errors[:group]).to include('を入力してください')
      end

      it 'is invalid without user_id' do
        message = build(:message, user_id: nil)
        message.valid?
        expect(message.errors[:user]).to include('を入力してください')
      end
    end
  end
end
