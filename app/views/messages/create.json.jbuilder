json.id                 @message.id
json.user_name          @message.user.name
json.content            @message.content
json.created_at         @message.created_at.strftime("%Y年%m月%d日 %H時%M分")