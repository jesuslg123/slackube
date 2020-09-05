require 'mqtt'

require_relative 'libs/SlackAPI.rb'
require_relative 'libs/Config.rb'
require_relative 'libs/MessageProcess.rb'


@config = Config.new('config.yml')
@message_process = MessageProcess.new(@config.status_list)
@slackAPI = SlackAPI.new(@config.token)
@client = MQTT::Client.connect(@config.mqtt_host, @config.mqtt_port)


@client.get(@config.mqtt_topic) do |topic,message|
    status = @message_process.message(topic, message)      
    @slackAPI.setStatus(status["text"], status["emoji"]) unless status.nil?
end