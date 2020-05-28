# frozen_string_literal: true

##
# Telegram represents a message containing multiple photos as multiple
# messages each containing a single photo.
class TelegramMessage
  attr_reader :user, :text, :reply, :photos

  def initialize(message)
    message = message.with_indifferent_access
    @text = message[:text] || message[:caption]
    @user = initialize_user(message)
    @reply = initialize_reply(message)
    @photos = initialize_photos(message)
  end

  private

  def initialize_user(message)
    telegram_chat_id = message.dig(:chat, :id)
    telegram_id = message.dig(:from, :id)
    first_name = message.dig(:from, :first_name)
    last_name = message.dig(:from, :last_name)
    username = message.dig(:from, :username)
    user = User.find_by(telegram_id: telegram_id)
    if user
      user.username = username
      user.telegram_chat_id = telegram_chat_id
    else
      user = User.new(
        telegram_id: telegram_id,
        telegram_chat_id: telegram_chat_id,
        username: username,
        first_name: first_name,
        last_name: last_name
      )
    end
    user
  end

  def initialize_reply(message)
    media_group_id = message['media_group_id']
    reply = Reply.find_by(telegram_media_group_id: media_group_id) if media_group_id
    reply ||= Reply.new(text: text, user: user, telegram_media_group_id: media_group_id)
    reply
  end

  ## Each photo from the Telegram API is available in multiple resolutions,
  # we save only the largest (i.e. original) variant.
  def initialize_photos(message)
    return [] unless message[:photo]

    photo = Photo.new
    bot_token = "bot#{Telegram.bots[Rails.configuration.bot_id].token}"
    telegram_file = message[:photo].max { |a, b| a[:file_size] <=> b[:file_size] }
    file_id = telegram_file[:file_id]
    uri = URI("https://api.telegram.org/#{bot_token}/getFile")
    uri.query = URI.encode_www_form({ file_id: file_id })
    response = JSON.parse(URI.open(uri).read)
    file_path = response.dig('result', 'file_path')
    remote_file_location = URI("https://api.telegram.org/file/#{bot_token}/#{file_path}")
    photo.image.attach(io: URI.open(remote_file_location), filename: File.basename(remote_file_location.path))
    [photo]
  end
end