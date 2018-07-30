$(function() {

var search_list = $("#user-search-result");

function appendUser(user) {
  var html = `<div class="chat-group-user clearfix">
                <p class="chat-group-user__name">ユーザー名</p>
                <a class="user-search-add chat-group-user__btn chat-group-user__btn--add" data-user-id="${ user.id }" data-user-name="${ user.name }">追加</a>
              </div>`
  search_list.append(html);
}

function appendNoUser(user) {
  var html  = `<div class="chat-group-user clearfix">
                <p>${ user }</p>
              </div>`
  search_list.append(html);
}

function deleteUser(user) {
  var html = `<div class='chat-group-user clearfix js-chat-member' id='chat-group-user-8'>
                <input name='group[user_ids][]' type='hidden' value='ユーザーのid'>
                <p class='chat-group-user__name'>ユーザー名</p>
                <a class='user-search-remove chat-group-user__btn chat-group-user__btn--remove js-remove-btn'>削除</a>
              </div>`
  search_list.append(html);
}

  $("#user-search-field").on("keyup", function() {
    var input = $("#user-search-field").val();

    $.ajax({
      type: 'GET',
      url: '/users/index',
      data: { keyword: input },
      dataType: 'json'
    })

    .done(function(users) {
      $("#user-search-result").empty();
      if (users.length !== 0) {
        users.forEach(function(user) {
          appendUser(user);
          $("#chat-group-user__btn--add").on("click", function() {
            $("chat-group-user").remove();
              deleteUser(user);
              $(".js-remove-btn").on("click", function() {
                $("chat-group-user").remove();
              })
          })
        });
      }
      else {
        appendNoUser("一致するユーザーはいませんでした。");
      }
    })
    .fail(function() {
      alert('ユーザー検索に失敗しました');
    })
  });
});
