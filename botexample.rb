include Facebook::Messenger

Bot.on :message do |message|
  # # TODO: Make bot replay something
  # message.reply(text: 'Hello, human!')
  text = message.text
  client = Client.find_or_create_by(
    uid: message.sender['id']
  )
  
  if text.end_with?('?')
    #suggest
    suggest = Suggest
    .where("? LIKE '%' || text || '%'", text[0..-2])
    .order('length(text) DESC')
    .limit(3)
    .sample
    if suggest
      message.reply(
        text: 'Do you want to say?',
        quick_replies:
          QuickReply.new(suggest.options)
        )
    else
      message.reply(text: 'again?')
    end
  else
    keyword = Keyword
    .where(group: client.context || '')
    .where("? LIKE '%' || text || '%'", text)
    .order('length(text) DESC')
    .limit(3)
    .sample
    if keyword
      client.update_attributes(
        context: keyword.context  
      )
      message.reply(text: keyword.reply)
    else
      message.reply(text: 'say what?')
    end
  end
end
