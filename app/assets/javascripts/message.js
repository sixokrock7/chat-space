$(function() {

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
  $('#new_comment').on('submit', function(e) {
    e.preventDefault();
    var formData = new FormData(this);
    var url = $(this).attr('action')
    $.ajax({
      url: url,
      type: "POST",
      data: formData,
      dataType: 'json',
      processData: false,
      contentType: false
    })
    .done(function(data){
      var html = buildHTML(data);
      $('.messages').append(html)
      $('.textbox').val('')
    })
  })
});
