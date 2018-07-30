json.array! @message do |message|
  json.content   message.content
  json.image     message.image
  json.user_id   message.user_id
end
