require 'rails_helper'

describe MessagesController do
  #letメソッドを用いて複数のexampleで同一のインスタンスを使用
  #letメソッドは初回の呼び出し時のみ実行される、複数回行なわれる処理を一度の処理で実装できる為、テストを高速に行える
  let(:group) { create(:group) }
  let(:user) { create(:user) }

  describe '#index' do

    context 'log in' do
      #beforeブロックの中に記述された処理は、各exampleが実行される直前に毎回実行される
      before do
        #loginメソッドを用いてdeviseを用いてログインをする
        login user
        #getメソッドを用いて擬似的にindexアクションを動かすリクエストを行う
        #getメソッドの引数として、params:{group_id: group.id}を渡す
        get :index, params: { group_id: group_id }
      end

      #assignsメソッドでインスタンス変数に代入されたオブジェクトを参照
      it 'assigns @message' do
        #expectの引数にassigns(:message)と記述することでMessage.newで定義された新しいMessageクラスのインスタンス@messageを参照
        #be_a_newマッチャを利用することで対象が引数で指定したクラスのインスタンスかつ未保存のレコードであるかどうか確認(assign(:message)がMessageクラスのインスタンスかつ未保存か確認)
        expect(assigns(:message)).to be_a_new(Message)
      end

      #eqマッチャを利用してassigns(:group)とgroupが同一であることをテスト
      it 'assigns @group' do
        expect(assigns(:group)).to eq group
      end

      #example内でリクエストが行われた後の遷移先のビューの情報を持つインスタンスであるresponseをexpectの引数に渡す
      #render_templateマッチャで引数に渡したindexアクションがリクエストされた時に自動的に遷移するビューを返す
      #この2つを合わせてexample内でリクエストが行われた時の遷移先のビューが、indexアクションのビューと同じかどうか確認
      it 'renders index' do
        expect(response).to render_template :index
      end
    end

    context 'not log in' do
      before get :index, params: { group_id: group.id }
    end

    #redirect_toマッチャでnew_user_session_pathにリダイレクトした際の情報を返す（非ログイン時にmessagesコントローラのindexアクションを動かすリクエストが行われた際に、ログイン画面にリダイレクトするかどうかを確認
      it 'redirects to new_user_session_path' do
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe '#create' do
    #letメソッドを用いてparamsを定義してcreateアクションを定義する際にgroup_id,user_id,messageを引数として渡す
    #attributes_forメソッドを用いてオブジェクトを生成せずにハッシュを生成する
    let(:params) { { group_id: group.id, user_id: user.id, message: attributes_for(:message) } }

    context 'log in' do
      before do
        login user
      end

      #contextブロックの内部でネストさせることで、ログインしている場合かつ保存に成功した場合を条件にグループを作成
      context 'can save' do
        subject {
          post :create,
          params: params
        }

        it 'count up message' do
          #expectの引数をsubjectを切り離して定義して渡す
          #「postメソッドでcreateアクションを擬似的にリクエストした結果」という意味のエクスペクテーション
          #changeマッチャを用いて引数が変化したかどうかを確かめ、createアクションのテストを行う
          #保存に成功した際にはレコード数が必ず1個増えるため、change(Message,:count).by(1)としてMessageモデルのレコードの総数が1個増えたかどうかを確認
          expect{ subject }.to change(Message, :count).by(1)
        end

        #意図した画面に遷移しているか確認
        it 'redirects to group_messages_path' do
          subject
          expect(response).to redirect_to(group_messages_path(group))
        end
      end

      #ログインしておりかつ、保存に失敗した場合
      context 'can not save' do
        #invalid_paramsを定義する際に、attributes_for(:message)の引数に、content: nil, image: nilと記述し,擬似的にcreateアクションをリクエストする際にinvalid_paramsを引数として渡してあげることによって、意図的にメッセージの保存に失敗する場合を再現
        let(:invalid_params) { { group_id: group.id, user_id: user.id, message: attributes_for(:message, content: nil, image: nil) } }
        subject {
          post :create,
          params: invalid_params
        }

        #Rspecで「〜でないこと」を期待する場合にはnot_toを使用
        #not_to change(Message, :count)と記述することによって、「Messageモデルのレコード数が変化しないこと ≒ 保存に失敗したこと」を確認
        it 'does not count up' do
          expect{ subject }.not_to change(Message, :count)
        end

        #メッセージの保存に失敗した場合、indexアクションのビューをrenderするよう設定
        it 'renders index' do
          subject
          expect(response).to render_template :index
        end
      end
    end

    #ログインしていない場合
    context 'not log in' do

      #ログインしていない場合にcreateアクションをリクエストした際は、ログイン画面へとリダイレクト
      it 'redirects to new_user_session_path' do
        #redirect_toマッチャの引数に、new_user_session_pathを取ることで、ログイン画面へとリダイレクトしているかどうかを確認
        post :create, params: params
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
