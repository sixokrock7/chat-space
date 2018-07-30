$(function() {
  /*テンプレートリテラル記法で文字列を複数で挿入
  サーバーから返されたデータであるjbuilderのデータをbuildHTMLの引数として渡しHTMLを追加する関数を定義*/
  function buildHTML(message) {
    var html = `<p>
                  <strong>
                    <a href=/users/${message.user_id}></a>
                    :
                    </strong>
                    ${message.content}
                    :
                    ${message.image}
                  </p>`
    return html;
  }
  /*idがnew_messageの要素を指定してjQueryオブジェクトを生成
  submitでフォームが送信された時、引数に取った関数を実行*/
  $('#new_message').on('submit', function(e) {
    /*フォームが送信された時、デフォルトだとフォームを送信するための通信が行われるため、preventDefault()を使用してデフォルトのイベントを止める*/
    e.preventDefault();
    /*thisを用いてイベントが発生したDOM要素であるnew_messageのIDでFormDataを用いてフォームの情報を取得、変数に格納*/
    var formData = new FormData(this);
    /*$(this)としてthisで取得できる要素をjQueryオブジェクト化、attrメソッドでaction属性の要素が持つ値を取得しリクエストを送信する先のURLを定義*/
    var url = $(this).attr('action')
    $.ajax({
      url: url,
      type: "POST",
      data: formData,
      dataType: 'json',
      /*dataで指定したオブジェクトをクエリ文字列(WebブラウザがWebサーバに送信するデータをURLの末尾に特定の形式で表記したもの)に変換、デフォルトではtrueになっているためfalseにする*/
      processData: false,
      /*デフォルトで「text/xml」となっているデータのファイル形式をAjaxリクエストがFormDataの際はfalseとして設定が上書きされるのを防ぐ*/
      contentType: false
    })
    /*非同期通信に成功した時、サーバから返されたデータであるjbuilderで作成したデータが入っているfunction関数を第一引数にとる*/
    .done(function(data){
      /*dataで指定した仮引数でHTMLを追加して変数に格納*/
      var html = buildHTML(data);
      /*append()を用いて引数で指定したHTML要素を追加*/
      $('.messages').append(html)
      /*val()を用いてフォームに入力された値を取得する*/
      $('.textbox').val('')
    })
    $('#btn').animate({scrollTop: $(#btn)})
    /*通信に失敗した時、アラートを表示*/
    .fail(function(){
      alert('error');
    })
  })
});
