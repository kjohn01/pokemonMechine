include Facebook::Messenger

Bot.on :message do |message|
  # # TODO: Make bot replay something
  # message.reply(text: 'Hello, human!')
  text = message.text
  client = Client.find_or_create_by(
    uid: message.sender['id']
  )
  
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
      
      if keyword.image.present?
        message.reply(
          attachment: {
            type: 'image',
            payload: {
              url: keyword.image
            }
          }  
        )
      end
      message.reply(text: keyword.reply)
      suggest = Suggest.first
      message.reply(
          text: '選一個神奇寶貝?',
          quick_replies:
            QuickReply.new(suggest.options)
          )
    else
      #suggest
      suggest = Suggest.first
      client.context = ''
      client.save!
      message.reply(
          text: '選一個神奇寶貝?',
          quick_replies:
            QuickReply.new(suggest.options)
          )

  end
end
