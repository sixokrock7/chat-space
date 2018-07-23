Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  #ルートパスにgroupsコントローラーのindexアクションを設定
  root "groups#index"
  #usersモデルのindex,edit,updateアクションのルーティングを設定
  resources :users, only: [:index, :edit, :update]
  #groupsモデルのnew,create,edit,updateアクションのルーティングを設定
  resources :groups, only: [:new, :create, :edit, :update] do
    #messagesモデルのindex,createアクションのルーティングを設定
    resources :messages, only: [:index, :create]
  end
end

