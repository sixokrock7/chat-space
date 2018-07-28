$(function() {
  $(".chat-group-form__input").on("keyup", function() {
    var input = $(".chat-group-form__input").val();

    $.ajax({
      type: 'GET',
      url: '/users/index',
      data: { keyword: input },
      dataType: 'json'
    })

    .done(function(users) {
      $(".");
      if (users.length !== 0) {
        users.forEach(function(user){
          appendProduct(product);
        });
      }
      else {
        appendNoProduct("一致するユーザーはいません");
      }
    }
  });
});
